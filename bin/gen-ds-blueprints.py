#!/usr/bin/env python3
"""Generate ds_* creature blueprints for Dungeon Solitaire card creatures.

Creates 40 dedicated blueprints (35 from existing module creatures + 5 named
placeholders) pre-configured with Merchant faction, empty inventory, and no
NWScript event handlers. Updates creaturepalcus.itp.json to list them all in
the Custom2 palette category alongside Meaningwave creatures.

Run from repo root:  python3 bin/gen-ds-blueprints.py
"""

import json, copy, sys
from pathlib import Path

UNPACKED = Path(__file__).parent.parent / "unpacked"
PALETTE  = UNPACKED / "creaturepalcus.itp.json"

SCRIPT_FIELDS = [
    "ScriptAttacked", "ScriptDamaged", "ScriptDeath", "ScriptDialogue",
    "ScriptDisturbed", "ScriptEndRound", "ScriptHeartbeat", "ScriptOnBlocked",
    "ScriptOnNotice", "ScriptRested", "ScriptSpawn", "ScriptSpellAt",
    "ScriptUserDefine",
]

# (output_resref, source_resref, palette_display_name, firstname_override)
# firstname_override: if set, replaces the blueprint's FirstName field.
MAPPED = [
    # Maiar
    ("ds_gandalf001",   "gandalf001",       "DS Radiant Olorin",          None),
    ("ds_alatar",       "alatar",           "DS Shining Curunir",         None),
    # Servants of Sauron
    ("ds_gothmog",      "thehighmageofbar", "DS Gothmog the Burning",     None),
    ("ds_hoarmouth",    "hoarmouththering", "DS Drowned Mouth of Sauron", None),
    ("ds_creature023",  "creature023",      "DS Khamul the Easterling",   None),
    ("ds_adunaphel",    "adunaphelther001", "DS Adunaphel the Quiet",     None),
    ("ds_witchking",    "angmartheevoocat", "DS Witch-king of Angmar",    None),
    # Orcs of Mordor
    ("ds_bandit007",    "bandit007",        "DS Grishnakh",               None),
    ("ds_urukai016",    "urukai016",        "DS Shagrat",                 None),
    ("ds_fiendofmorgul","fiendofmorgul",    "DS Gorbag",                  None),
    # Uruk-hai
    ("ds_urukai020",    "urukai020",        "DS Ugluk",                   None),
    ("ds_urukai003",    "urukai003",        "DS Lurtz",                   None),
    ("ds_mauhur",       "urukhaifirstborn", "DS Mauhur",                  None),
    ("ds_urukai012",    "urukai012",        "DS Isengard Executioner",    None),
    ("ds_urukai013",    "urukai013",        "DS Isengard Warchief",       None),
    ("ds_urukai001",    "urukai001",        "DS Isengard Squire",         None),
    # Hobbits / Shire
    ("ds_hobbit001",    "hobbit001",        "DS Bill the Pony",           None),
    ("ds_bilbobaggins", "bilbobaggins",     "DS Bilbo Baggins",           None),
    ("ds_samwise",      "samwise",          "DS Samwise Gamgee",          None),
    # Rohan
    ("ds_eowyn",        "eowyntheshieldma", "DS Eowyn Shieldmaiden",      None),
    # Rangers of the North
    ("ds_halbarad",     "rangerofthe003",   "DS Halbarad",                None),
    # Elladan and Elrohir share a source resref but need separate blueprints
    ("ds_elladan",      "elfranger016",     "DS Elladan",                 "Elladan"),
    ("ds_elrohir",      "elfranger016",     "DS Elrohir",                 "Elrohir"),
    # Wood-elves of Mirkwood
    ("ds_beorning",     "bearbeorning001",  "DS Silvan Shapeshifter",     None),
    ("ds_mirkwood",     "mirkwoodforestwa", "DS Mirkwood Shade",          None),
    ("ds_creature018",  "creature018",      "DS Thranduil's Scout",       None),
    ("ds_legolas",      "legolasgreenl001", "DS Legolas Greenleaf",       None),
    # Fellowship / Gondor
    ("ds_aragorn",      "aragornsonofarat", "DS Aragorn Strider",         None),
    ("ds_creature009",  "creature009",      "DS Boromir",                 None),
    ("ds_creature002",  "creature002",      "DS Faramir",                 None),
    ("ds_creature003",  "creature003",      "DS Denethor",                None),
    ("ds_beregond",     "gondorianguar002", "DS Beregond",                None),
    ("ds_gimli",        "gimli",            "DS Gimli Son of Gloin",      None),
    ("ds_galadriel",    "galadriel",        "DS Galadriel",               None),
    ("ds_saruman",      "sarumanthewhi001", "DS Saruman the White",       None),
]

# Placeholder blueprints for cards with no module creature equivalent.
# Based on gimli (Dwarf = Old Tagget style appearance) with name overridden.
# (output_resref, palette_display_name, blueprint_firstname)
PLACEHOLDERS = [
    ("ds_frodo",  "DS Frodo Baggins",        "Frodo Baggins"),
    ("ds_merry",  "DS Meriadoc Brandybuck",  "Meriadoc Brandybuck"),
    ("ds_pippin", "DS Peregrin Took",        "Peregrin Took"),
    ("ds_grima",  "DS Grima Wormtongue",     "Grima Wormtongue"),
    ("ds_eomer",  "DS Eomer of the Eastmark","Eomer of the Eastmark"),
]


def make_inert(bp: dict) -> dict:
    """Apply Merchant faction, empty inventory, and blank all event scripts."""
    bp["FactionID"] = {"type": "word", "value": 3}  # 3 = Merchant
    if "ItemList" in bp:
        bp["ItemList"]["value"] = []
    for field in SCRIPT_FIELDS:
        if field in bp:
            bp[field]["value"] = ""
        # If the field isn't present at all, add it (some blueprints omit unused slots)
        else:
            bp[field] = {"type": "resref", "value": ""}
    return bp


def set_firstname(bp: dict, name: str) -> dict:
    bp["FirstName"] = {"type": "cexolocstring", "value": {"0": name}}
    bp["LastName"]  = {"type": "cexolocstring", "value": {"0": ""}}
    return bp


def get_cr(bp: dict) -> float:
    return bp.get("ChallengeRating", {}).get("value", 1.0)


def get_firstname_str(bp: dict) -> str:
    fn = bp.get("FirstName", {})
    val = fn.get("value", {}) if isinstance(fn, dict) else {}
    return val.get("0", "") if isinstance(val, dict) else str(val)


palette_entries = []

# --- Group A: mapped blueprints ---
print(f"Generating {len(MAPPED)} mapped blueprints...")
for out_resref, src_resref, palette_name, firstname_override in MAPPED:
    src = UNPACKED / f"{src_resref}.utc.json"
    if not src.exists():
        print(f"  SKIP (source missing): {src_resref}")
        continue
    with open(src) as f:
        bp = json.load(f)
    bp = make_inert(copy.deepcopy(bp))
    if firstname_override:
        bp = set_firstname(bp, firstname_override)
    out = UNPACKED / f"{out_resref}.utc.json"
    with open(out, "w") as f:
        json.dump(bp, f, indent=2)
    palette_entries.append((out_resref, palette_name, get_cr(bp)))
    print(f"  {src_resref} -> {out_resref}.utc.json")

# --- Group B: placeholder blueprints (based on gimli) ---
gimli_src = UNPACKED / "gimli.utc.json"
if not gimli_src.exists():
    print("ERROR: gimli.utc.json not found — cannot create placeholder blueprints")
    sys.exit(1)

with open(gimli_src) as f:
    gimli_bp = json.load(f)
gimli_cr = get_cr(gimli_bp)

print(f"\nGenerating {len(PLACEHOLDERS)} placeholder blueprints (Dwarf/Old Tagget appearance)...")
for out_resref, palette_name, firstname in PLACEHOLDERS:
    bp = make_inert(copy.deepcopy(gimli_bp))
    bp = set_firstname(bp, firstname)
    out = UNPACKED / f"{out_resref}.utc.json"
    with open(out, "w") as f:
        json.dump(bp, f, indent=2)
    palette_entries.append((out_resref, palette_name, gimli_cr))
    print(f"  {out_resref}.utc.json  ({firstname})")

# --- Update creaturepalcus.itp.json ---
print(f"\nUpdating palette ({len(palette_entries)} new entries in Custom2)...")
with open(PALETTE) as f:
    pal = json.load(f)

custom2_list = pal["MAIN"]["value"][2]["LIST"]["value"][2]["LIST"]["value"]

# Remove any existing ds_* entries to avoid duplicates on re-run
custom2_list[:] = [e for e in custom2_list if not e.get("RESREF", {}).get("value", "").startswith("ds_")]

for out_resref, palette_name, cr in sorted(palette_entries, key=lambda x: x[1]):
    custom2_list.append({
        "__struct_id": 0,
        "CR":      {"type": "float",     "value": cr},
        "FACTION": {"type": "cexostring", "value": "Merchant"},
        "NAME":    {"type": "cexostring", "value": palette_name},
        "RESREF":  {"type": "resref",     "value": out_resref},
    })

with open(PALETTE, "w") as f:
    json.dump(pal, f, indent=2)

total_ds = len(list(UNPACKED.glob("ds_*.utc.json")))
print(f"\nDone. {total_ds} ds_*.utc.json files in unpacked/")
print(f"      Custom2 now has {len(custom2_list)} entries")
