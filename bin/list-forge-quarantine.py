#!/usr/bin/env python3
"""List items sequestered in the Forge Warden's quarantine chest.

When a player disputes the legality of a flagged item at the Forge Warden
(Pit Prison), the item is sequestered for DM review rather than reverted or
destroyed.  ForgeQuarantineDisputedItem() (unpacked/forge_inc.nss) and the
donation scanner (unpacked/welloferuenter.nss) both write into the legacy
campaign database "craftdb" using these keys:

    quarantine_count          (int)    number of sequestered items
    quarantine_<N>            (object) the serialized item (GFF blob)
    quarantine_<N>_info       (string) human-readable provenance line, e.g.
        "[FORGE DISPUTE] Item '<name>' (resref: <r>, props <p>, value <v>)
         sequestered from <character> (account: <playername>) pending DM review."

A DM later restocks these into the ZEP_CR_QUARANTINE chest (House of Homer)
to adjudicate.  This script reads craftdb directly and prints, for every
sequestered item, the player account, character name and as much item detail
as can be recovered from both the info line and the serialized item itself.

The legacy campaign DB is an NWN:EE SQLite file (table `db`, columns
varname/playerid/vartype/payload/compressed).  vartype is the ASCII code of
the GFF type letter ('I'=73 int, 'S'=83 string, 'O'=79 object).  Object
payloads are a "CPDB" wrapper around a zstd-compressed GFF.
"""

import argparse
import os
import re
import sqlite3
import struct
import sys

ZSTD_MAGIC = bytes.fromhex("28b52ffd")


def default_db_path() -> str:
    home = os.environ.get("NWN_HOME_DIR") or os.path.join(
        os.path.expanduser("~"), ".local", "share", "Neverwinter Nights"
    )
    return os.path.join(home, "database", "craftdb.sqlite3")


# ---------------------------------------------------------------------------
# campaign-DB value decoding
# ---------------------------------------------------------------------------

def _zstd_decompress(buf: bytes) -> bytes:
    try:
        from compression import zstd  # Python >= 3.14
        return zstd.decompress(buf)
    except Exception:
        import zstandard  # pip install zstandard
        return zstandard.ZstdDecompressor().decompress(buf)


def decode_int(payload: bytes) -> int:
    # Stored as decimal ASCII text in the legacy EE campaign DB.
    return int(payload.decode("latin1").strip() or "0")


def decode_string(payload: bytes, compressed: int) -> str:
    if compressed:
        z = payload.find(ZSTD_MAGIC)
        payload = _zstd_decompress(payload[z:] if z != -1 else payload)
    text = payload.split(b"\x00")[0]
    try:
        return text.decode("utf-8")
    except UnicodeDecodeError:
        return text.decode("latin1")


def extract_gff(payload: bytes, compressed: int) -> bytes:
    """Return the raw GFF bytes from a stored-object payload."""
    z = payload.find(ZSTD_MAGIC)
    if z != -1:
        return _zstd_decompress(payload[z:])
    for magic in (b"UTI ", b"UTC ", b"UTP ", b"UTM ", b"UTW "):
        i = payload.find(magic)
        if i != -1:
            return payload[i:]
    return payload  # let the GFF parser fail loudly if this isn't GFF


# ---------------------------------------------------------------------------
# minimal GFF reader (top-level struct only)
# ---------------------------------------------------------------------------

class Gff:
    # field type ids we care about
    BYTE, CHAR, WORD, SHORT, DWORD, INT = 0, 1, 2, 3, 4, 5
    DWORD64, INT64, FLOAT, DOUBLE = 6, 7, 8, 9
    CEXOSTRING, RESREF, CEXOLOCSTRING, VOID, STRUCT, LIST = 10, 11, 12, 13, 14, 15

    def __init__(self, data: bytes):
        self.data = data
        self.ftype = data[0:4].decode("latin1").rstrip()
        (self.struct_off, _sc, self.field_off, _fc, self.label_off, _lc,
         self.fielddata_off, _fdc, self.fieldidx_off, _fic,
         self.listidx_off, _lic) = struct.unpack_from("<12I", data, 8)

    def _label(self, i: int) -> str:
        raw = self.data[self.label_off + i * 16: self.label_off + i * 16 + 16]
        return raw.split(b"\x00")[0].decode("latin1")

    def _field(self, idx: int):
        ftype, labelidx, dataoff = struct.unpack_from(
            "<III", self.data, self.field_off + idx * 12)
        return ftype, self._label(labelidx), dataoff

    def struct_fields(self, struct_index: int = 0) -> dict:
        # struct 0 is always the top-level struct
        stype, dataoff, fcount = struct.unpack_from(
            "<III", self.data, self.struct_off + struct_index * 12)
        fields = {}
        if fcount == 1:
            ftype, name, doff = self._field(dataoff)
            fields[name] = (ftype, doff)
        else:
            for k in range(fcount):
                fidx = struct.unpack_from(
                    "<I", self.data, self.fieldidx_off + dataoff + k * 4)[0]
                ftype, name, doff = self._field(fidx)
                fields[name] = (ftype, doff)
        return fields

    # backwards-compatible alias
    def top_fields(self) -> dict:
        return self.struct_fields(0)

    def list_struct_indices(self, name: str, fields: dict):
        """Return the struct indices of every element in a LIST field."""
        if name not in fields:
            return []
        ftype, doff = fields[name]
        if ftype != self.LIST:
            return []
        size = struct.unpack_from("<I", self.data, self.listidx_off + doff)[0]
        return list(struct.unpack_from(
            f"<{size}I", self.data, self.listidx_off + doff + 4))

    def local_var(self, name: str, fields: dict):
        """Read a local variable by name from the object's VarTable list."""
        for sidx in self.list_struct_indices("VarTable", fields):
            sf = self.struct_fields(sidx)
            if self.value("Name", sf) == name:
                return self.value("Value", sf)
        return None

    def value(self, name: str, fields: dict):
        if name not in fields:
            return None
        ftype, doff = fields[name]
        d = self.data
        if ftype in (self.BYTE, self.WORD, self.DWORD):
            return doff
        if ftype in (self.CHAR, self.SHORT, self.INT):
            # doff is the raw little-endian uint32; reinterpret signed
            return struct.unpack("<i", struct.pack("<I", doff))[0]
        if ftype == self.FLOAT:
            return struct.unpack("<f", struct.pack("<I", doff))[0]
        base = self.fielddata_off + doff
        if ftype == self.CEXOSTRING:
            ln = struct.unpack_from("<I", d, base)[0]
            return d[base + 4: base + 4 + ln].decode("latin1")
        if ftype == self.RESREF:
            ln = d[base]
            return d[base + 1: base + 1 + ln].decode("latin1")
        if ftype == self.CEXOLOCSTRING:
            total, strref, count = struct.unpack_from("<III", d, base)
            p = base + 12
            for _ in range(count):
                strid, ln = struct.unpack_from("<II", d, p)
                txt = d[p + 8: p + 8 + ln].decode("latin1")
                if txt:
                    return txt
                p += 8 + ln
            return f"(strref {strref})" if strref not in (0, 0xFFFFFFFF) else None
        return None


# ---------------------------------------------------------------------------
# reporting
# ---------------------------------------------------------------------------

# base item ids -> readable names (common item types; unknown ids fall through)
BASE_ITEMS = {
    0: "Short Sword", 1: "Longsword", 2: "Battleaxe", 3: "Bastard Sword",
    4: "Light Flail", 5: "Warhammer", 6: "Heavy Crossbow", 7: "Light Crossbow",
    8: "Longbow", 9: "Light Mace", 10: "Halberd", 11: "Shortbow",
    12: "Two-Bladed Sword", 13: "Greatsword", 14: "Greataxe", 15: "Dart",
    16: "Dagger", 17: "Club", 18: "Throwing Axe", 19: "Kama", 20: "Katana",
    21: "Kukri", 22: "Morning Star", 23: "Quarterstaff", 24: "Rapier",
    25: "Scimitar", 26: "Scythe", 27: "Shortspear", 28: "Shuriken",
    29: "Sickle", 30: "Sling", 31: "Spear", 32: "Heavy Flail",
    33: "Dire Mace", 34: "Double Axe", 35: "Helmet", 36: "Small Shield",
    37: "Torch", 38: "Armor", 39: "Large Shield", 40: "Tower Shield",
    41: "Trap Kit", 42: "Bullet", 43: "Bolt", 44: "Arrow", 45: "Bracers",
    46: "Boots", 49: "Gloves", 50: "Cloak", 52: "Healer's Kit",
    53: "Thieves' Tools", 54: "Amulet", 55: "Belt", 56: "Ring",
    57: "Magic Wand", 58: "Magic Staff", 59: "Magic Rod", 61: "Potion",
    63: "Scroll", 64: "Blank Scroll", 68: "Gold", 73: "Miscellaneous Small",
    74: "Crafting Material", 75: "Miscellaneous Medium", 80: "Gem",
    104: "Spell Scroll",
}

INFO_RE = re.compile(
    r"Item '(?P<name>.*?)'.*?resref:\s*(?P<resref>[^,]*).*?"
    r"props\s*(?P<props>\d+).*?value\s*(?P<value>\d+).*?"
    r"sequestered from (?P<char>.*?) \(account:\s*(?P<account>.*?)\)",
    re.DOTALL,
)


def parse_info(info: str) -> dict:
    m = INFO_RE.search(info or "")
    return m.groupdict() if m else {}


def describe_item(gff_bytes: bytes) -> dict:
    try:
        g = Gff(gff_bytes)
        f = g.top_fields()
    except Exception as e:  # malformed/unexpected blob — don't abort the run
        return {"_error": f"could not parse item GFF: {e}"}
    base = g.value("BaseItem", f)
    out = {
        "name": g.value("LocalizedName", f),
        "tag": g.value("Tag", f),
        "resref": g.value("TemplateResRef", f),
        "base_item": base,
        "base_item_name": BASE_ITEMS.get(base) if base is not None else None,
        "stack": g.value("StackSize", f),
        "identified": g.value("Identified", f),
        "charges": g.value("Charges", f),
        "cost": g.value("Cost", f),
        "add_cost": g.value("AddCost", f),
        "plot": g.value("Plot", f),
        "stolen": g.value("Stolen", f),
        "description": g.value("Description", f) or g.value("DescIdentified", f),
        # Provenance stamped onto the item at quarantine time (forge_inc.nss /
        # welloferuenter.nss). Persists with the object inside the chest snapshot
        # until a DM removes the item, unlike the transient quarantine_*_info row.
        "quarantine_info": g.local_var("QUARANTINE_INFO", f),
    }
    return out


def print_item(label: str, detail: dict, info: str) -> None:
    """Render one quarantined item. `info` is the best provenance string we
    have (item-embedded QUARANTINE_INFO, or the transient _info row)."""
    meta = parse_info(info)
    name = detail.get("name") or meta.get("name") or "(unknown item)"
    print(f"\n{label} {name}")
    print(f"     Player (account) : {meta.get('account', '?')}")
    print(f"     Character        : {meta.get('char', '?')}")

    resref = detail.get("resref") or meta.get("resref")
    if resref:
        print(f"     ResRef           : {resref}")
    if detail.get("tag"):
        print(f"     Tag              : {detail['tag']}")
    bi = detail.get("base_item")
    if bi is not None:
        bi_label = detail.get("base_item_name") or f"id {bi}"
        print(f"     Base item        : {bi_label} ({bi})")
    if meta.get("value"):
        print(f"     Value (at seize) : {meta['value']} gp")
    if detail.get("cost") is not None or detail.get("add_cost") is not None:
        print(f"     Cost / AddCost   : {detail.get('cost')} / {detail.get('add_cost')}")
    if meta.get("props"):
        print(f"     Property count   : {meta['props']}")
    if detail.get("stack") not in (None, 1):
        print(f"     Stack size       : {detail['stack']}")
    if detail.get("charges"):
        print(f"     Charges          : {detail['charges']}")
    if detail.get("identified") is not None:
        print(f"     Identified       : {'yes' if detail['identified'] else 'no'}")
    if detail.get("plot"):
        print(f"     Plot flag        : yes")
    if detail.get("stolen"):
        print(f"     Stolen flag      : yes")
    if detail.get("description"):
        desc = " ".join(detail["description"].split())
        if len(desc) > 200:
            desc = desc[:197] + "..."
        print(f"     Description      : {desc}")
    if detail.get("_error"):
        print(f"     [warn] {detail['_error']}")
    if info:
        print(f"     Provenance log   : {info}")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--db", default=default_db_path(),
                    help="path to craftdb.sqlite3 (default: %(default)s)")
    args = ap.parse_args()

    if not os.path.exists(args.db):
        print(f"Database not found: {args.db}", file=sys.stderr)
        return 1

    con = sqlite3.connect(f"file:{args.db}?mode=ro", uri=True)
    con.row_factory = sqlite3.Row

    def get(varname):
        return con.execute(
            "SELECT vartype, payload, compressed FROM db WHERE varname = ?",
            (varname,),
        ).fetchone()

    def describe(item_row):
        if item_row is None:
            return {}
        try:
            return describe_item(extract_gff(item_row["payload"], item_row["compressed"]))
        except Exception as e:
            return {"_error": f"could not decode object payload: {e}"}

    print("=" * 78)
    print(f"Forge Warden quarantine chest  —  {args.db}")
    print("=" * 78)

    # --- Items physically in the chest (persistent snapshot, last OnClose) ---
    # These survive until a DM removes the item from the chest. Provenance is
    # read from the item-embedded QUARANTINE_INFO local var (see forge_inc.nss).
    chest_row = get("chest_count")
    chest_count = decode_int(chest_row["payload"]) if chest_row else 0
    in_chest = 0
    print(f"\n### In the quarantine chest ({chest_count} item(s) at last close) ###")
    if chest_count == 0:
        print("  (empty, or the chest has not been closed since the last reboot)")
    for n in range(chest_count):
        item_row = get(f"chest_{n}")
        if item_row is None:
            continue
        in_chest += 1
        detail = describe(item_row)
        print_item(f"[chest {n}]", detail, detail.get("quarantine_info") or "")

    # --- Items still in the inbox (quarantined, chest not yet opened since) ---
    # These vanish into the chest on the next chest open. Provenance comes from
    # the transient quarantine_*_info row (and the embedded var as a fallback).
    q_row = get("quarantine_count")
    q_count = decode_int(q_row["payload"]) if q_row else 0
    in_inbox = 0
    print(f"\n### Pending inbox — not yet pulled into the chest "
          f"({q_count} item(s)) ###")
    if q_count == 0:
        print("  (none)")
    for n in range(q_count):
        info_row = get(f"quarantine_{n}_info")
        item_row = get(f"quarantine_{n}")
        if info_row is None and item_row is None:
            continue
        in_inbox += 1
        detail = describe(item_row)
        info = ""
        if info_row is not None:
            info = decode_string(info_row["payload"], info_row["compressed"])
        if not info:
            info = detail.get("quarantine_info") or ""
        print_item(f"[inbox {n}]", detail, info)

    print("\n" + "-" * 78)
    print(f"{in_chest} item(s) in the chest, {in_inbox} pending in the inbox.")
    if in_chest == 0 and in_inbox == 0:
        print("No items are currently sequestered for DM review.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
