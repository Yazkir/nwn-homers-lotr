#!/usr/bin/env python3
"""Inject the forge disenchant sub-conversation into the three forge dialogs.

Appends (never renumbers) a shared subtree to each dialog:

  Entry D1  "Which enchantment shall I strike..."  (Script: forge_dis_anvil)
    -> 8 token replies <CUSTOM6110..6117> (Active: forge_dis_cN, Script: forge_dis_pN)
         -> Entry D2 confirm "<CUSTOM6118>"
              -> "Yes, strike it..." (Script: forge_dis_go) -> back to D1 (child link)
              -> "No..."                                    -> back to D1 (child link)
    -> "Never mind." (ends)

and hooks a new reply "Strip an enchantment..." (gated by isitemonanvil) into
every menu entry that already offers the "modify the item" reply (ReplyList[1]).

Idempotent: skips a dialog that already contains the hook reply text.
"""

import json
import sys
from pathlib import Path

DIALOGS = [
    "forge_item_mid.dlg.json",
    "kimli_forge.dlg.json",
    "bellnius_smith.dlg.json",
]

HOOK_TEXT = "Strip an enchantment from the item on the anvil. (no refund)"
D1_TEXT = ("Which enchantment shall I strike from the <CUSTOM100>? "
           "Mind you — the magic is lost forever, and I pay nothing for unmaking.")
D2_TEXT = ("Strike the <CUSTOM6118> from it? There is no refund and no undoing.")
YES_TEXT = "Yes, strike it. The magic is forfeit."
NO_TEXT = "No, leave it be."
NEVERMIND_TEXT = "Never mind."


def resref(v):
    return {"type": "resref", "value": v}


def locstring(text):
    return {"type": "cexolocstring", "value": {"0": text}}


def link(struct_id, index, active="", child=False):
    d = {
        "__struct_id": struct_id,
        "Active": resref(active),
        "Index": {"type": "dword", "value": index},
        "IsChild": {"type": "byte", "value": 1 if child else 0},
    }
    if child:
        d["LinkComment"] = {"type": "cexostring", "value": ""}
    return d


def node(struct_id, text, script="", entry=False):
    d = {
        "__struct_id": struct_id,
        "Animation": {"type": "dword", "value": 0},
        "AnimLoop": {"type": "byte", "value": 1},
        "Comment": {"type": "cexostring", "value": ""},
        "Delay": {"type": "dword", "value": 4294967295},
        "Quest": {"type": "cexostring", "value": ""},
        "Script": resref(script),
        "Sound": resref(""),
        "Text": locstring(text),
    }
    if entry:
        d["Speaker"] = {"type": "cexostring", "value": ""}
        d["RepliesList"] = {"type": "list", "value": []}
    else:
        d["EntriesList"] = {"type": "list", "value": []}
    return d


def inject(path: Path) -> bool:
    data = json.loads(path.read_text())
    entries = data["EntryList"]["value"]
    replies = data["ReplyList"]["value"]

    for r in replies:
        if r["Text"]["value"].get("0") == HOOK_TEXT:
            print(f"{path.name}: already injected, skipping")
            return False

    # Anchor entries: those whose RepliesList links the anvil-menu reply (index
    # 1, the one carrying the isitemonanvil-gated link in all three dialogs).
    anchors = []
    for ei, e in enumerate(entries):
        for l in e["RepliesList"]["value"]:
            if l["Index"]["value"] == 1:
                ischild = l.get("IsChild", {}).get("value", 0)
                anchors.append((ei, ischild))
                break
    if not anchors:
        raise SystemExit(f"{path.name}: no anchor entry links ReplyList[1]")

    d1 = len(entries)       # disenchant menu entry
    d2 = d1 + 1             # confirm entry
    r_slot0 = len(replies)  # 8 slot replies: r_slot0 .. r_slot0+7
    r_never = r_slot0 + 8
    r_yes = r_slot0 + 9
    r_no = r_slot0 + 10
    r_hook = r_slot0 + 11

    # Entry D1: slot replies (owned here) + never mind.
    e1 = node(d1, D1_TEXT, script="forge_dis_anvil", entry=True)
    for n in range(8):
        e1["RepliesList"]["value"].append(
            link(n, r_slot0 + n, active=f"forge_dis_c{n}"))
    e1["RepliesList"]["value"].append(link(8, r_never))

    # Entry D2: yes/no (owned here).
    e2 = node(d2, D2_TEXT, entry=True)
    e2["RepliesList"]["value"].append(link(0, r_yes))
    e2["RepliesList"]["value"].append(link(1, r_no))

    new_replies = []
    for n in range(8):
        r = node(r_slot0 + n, f"<CUSTOM{6110 + n}>", script=f"forge_dis_p{n}")
        # First slot owns D2; the rest reference it as child links.
        r["EntriesList"]["value"].append(link(0, d2, child=(n != 0)))
        new_replies.append(r)

    new_replies.append(node(r_never, NEVERMIND_TEXT))  # ends conversation

    r = node(r_yes, YES_TEXT, script="forge_dis_go")
    r["EntriesList"]["value"].append(link(0, d1, child=True))
    new_replies.append(r)

    r = node(r_no, NO_TEXT)
    r["EntriesList"]["value"].append(link(0, d1, child=True))
    new_replies.append(r)

    r = node(r_hook, HOOK_TEXT)
    r["EntriesList"]["value"].append(link(0, d1))  # hook reply owns D1
    new_replies.append(r)

    entries.extend([e1, e2])
    replies.extend(new_replies)

    # Hook the new reply into every anchor menu entry. The entry that owns
    # ReplyList[1] (IsChild=0) owns the hook too; others get child links.
    for ei, ischild in anchors:
        rl = entries[ei]["RepliesList"]["value"]
        rl.append(link(len(rl), r_hook, active="isitemonanvil",
                       child=(ischild == 1)))

    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    print(f"{path.name}: injected (D1=entry {d1}, D2=entry {d2}, "
          f"replies {r_slot0}..{r_hook}, anchors {[a for a, _ in anchors]})")
    return True


def main():
    root = Path(__file__).resolve().parent.parent / "unpacked"
    for name in DIALOGS:
        inject(root / name)


if __name__ == "__main__":
    main()
