#!/usr/bin/env python3
"""Generate the Dungeon Solitaire GFF assets that are tedious to hand-write:
   - unpacked/ds_facedown.utp.json  (face-down card statue placeable)
   - unpacked/ds_attack.dlg.json    (ally -> pick-a-column conversation)
Run from anywhere; writes into the module's unpacked/ dir.
"""
import json, os

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", "..", "unpacked"))

def rs(v):  return {"type": "resref", "value": v}
def cs(v):  return {"type": "cexostring", "value": v}
def by(v):  return {"type": "byte", "value": v}
def sh(v):  return {"type": "short", "value": v}
def dw(v):  return {"type": "dword", "value": v}
def wd(v):  return {"type": "word", "value": v}
def loc(v): return {"type": "cexolocstring", "value": {"0": v} if v else {}}
def lst(v): return {"type": "list", "value": v}

# ── ds_facedown.utp.json : a generic statue used for hidden/face-down cards ──────
facedown = {
    "__data_type": "UTP ",
    "AnimationState": by(0),
    "Appearance": dw(91),              # 91 = "Statue"
    "AutoRemoveKey": by(0),
    "BodyBag": by(0),
    "CloseLockDC": by(0),
    "Comment": cs("Dungeon Solitaire: face-down card. Spawned at runtime by the DungeonSolitaire plugin."),
    "Conversation": rs(""),
    "CurrentHP": sh(15),
    "Description": loc("A face-down card. Defeat the card in front of it to reveal what lies beneath."),
    "DisarmDC": by(0),
    "Faction": dw(1),
    "Fort": by(0),
    "Hardness": by(5),
    "HasInventory": by(0),
    "HP": sh(15),
    "Interruptable": by(1),
    "KeyName": cs(""),
    "KeyRequired": by(0),
    "Lockable": by(0),
    "Locked": by(0),
    "LocName": loc("Face-down card"),
    "OnClosed": rs(""), "OnDamaged": rs(""), "OnDeath": rs(""), "OnDisarm": rs(""),
    "OnHeartbeat": rs(""), "OnInvDisturbed": rs(""), "OnLock": rs(""), "OnMeleeAttacked": rs(""),
    "OnOpen": rs(""), "OnSpellCastAt": rs(""), "OnTrapTriggered": rs(""), "OnUnlock": rs(""),
    "OnUsed": rs(""), "OnUserDefined": rs(""),
    "OpenLockDC": by(0),
    "PaletteID": by(6),
    "Plot": by(1),
    "PortraitId": wd(0),
    "Ref": by(0),
    "Static": by(0),                   # non-static so the plugin can spawn/destroy it
    "Tag": cs("ds_facedown"),
    "TemplateResRef": rs("ds_facedown"),
    "TrapDetectable": by(0), "TrapDetectDC": by(0), "TrapDisarmable": by(0),
    "TrapFlag": by(0), "TrapOneShot": by(1), "TrapType": by(0),
    "Type": by(0),
    "Useable": by(1),                  # clickable so curious players can examine it
    "Will": by(0),
}
with open(os.path.join(ROOT, "ds_facedown.utp.json"), "w") as f:
    json.dump(facedown, f, indent=2)

# ── ds_attack.dlg.json : click an ally -> choose a target column ─────────────────
def reply_node(sid, text, script):
    return {
        "__struct_id": sid,
        "Animation": dw(0), "AnimLoop": by(1),
        "Comment": cs(""), "Delay": dw(4294967295),
        "EntriesList": lst([]),        # empty -> ends the conversation
        "Quest": cs(""),
        "Script": rs(script),
        "Sound": rs(""),
        "Text": loc(text),
    }

# PC replies: 5 columns, the AoE "unleash", and a cancel.
replies = [
    reply_node(0, "Attack the first column.",  "ds_atk1"),
    reply_node(1, "Attack the second column.", "ds_atk2"),
    reply_node(2, "Attack the third column.",  "ds_atk3"),
    reply_node(3, "Attack the fourth column.", "ds_atk4"),
    reply_node(4, "Attack the fifth column.",  "ds_atk5"),
    reply_node(5, "Unleash its power upon the dungeon!", "ds_atkaoedo"),
    reply_node(6, "Hold — not this one.", ""),
]

# Links from the NPC entry to each reply, each gated by its conditional.
def link(sid, index, active):
    return {"__struct_id": sid, "Active": rs(active), "Index": dw(index), "IsChild": by(0)}

reply_links = [
    link(0, 0, "ds_atkc1"),
    link(1, 1, "ds_atkc2"),
    link(2, 2, "ds_atkc3"),
    link(3, 3, "ds_atkc4"),
    link(4, 4, "ds_atkc5"),
    link(5, 5, "ds_atkaoe"),
    link(6, 6, ""),                    # cancel always shows
]

entry = {
    "__struct_id": 0,
    "Animation": dw(0), "AnimLoop": by(1),
    "Comment": cs("E_DS_ATTACK"),
    "Delay": dw(4294967295),
    "Quest": cs(""),
    "RepliesList": lst(reply_links),
    "Script": rs(""),
    "Sound": rs(""),
    "Text": loc("This ally awaits your command. Which target shall it strike?"),
}

dlg = {
    "__data_type": "DLG ",
    "DelayEntry": dw(0),
    "DelayReply": dw(0),
    "EndConverAbort": rs(""),
    "EndConversation": rs(""),
    "EntryList": lst([entry]),
    "NumWords": dw(0),
    "PreventZoomIn": by(1),
    "ReplyList": lst(replies),
    "StartingList": lst([{"__struct_id": 0, "Active": rs(""), "Index": dw(0)}]),
}
with open(os.path.join(ROOT, "ds_attack.dlg.json"), "w") as f:
    json.dump(dlg, f, indent=2)

# ── ds_choice.dlg.json : generic paged popup for secondary mid-turn choices ──────
# Spoken by the session's invisible narrator and popped by the plugin whenever the
# engine needs a discard / target / effect-order / yes-no decision (replacing the
# old auto-pick-first behaviour). All visible text comes from custom tokens the
# plugin sets via NWScript.SetCustomToken before each popup, so one static dialog
# renders any option list:
#   <CUSTOM5400>          prompt (the InputRequest context)
#   <CUSTOM5401..5410>    the 10 option slots of the current page
#   <CUSTOM5411>          the "more options" pager label
# Keep these IDs in sync with DsConfig.Choice*Token.
PAGE = 10

choice_replies = [
    reply_node(i, "<CUSTOM%d>" % (5401 + i), "ds_chs%d" % i) for i in range(PAGE)
]
# "more options" loops back to the entry (index 0) so the next page redraws in place.
choice_replies.append({
    "__struct_id": PAGE,
    "Animation": dw(0), "AnimLoop": by(1),
    "Comment": cs(""), "Delay": dw(4294967295),
    "EntriesList": lst([link(0, 0, "")]),
    "Quest": cs(""),
    "Script": rs("ds_chnext"),
    "Sound": rs(""),
    "Text": loc("<CUSTOM5411>"),
})
# cancel: no script, empty EntriesList -> conversation ends -> EndConv* = ds_chend.
choice_replies.append(reply_node(PAGE + 1, "Hold — leave it for now.", ""))

choice_links = [link(i, i, "ds_chc%d" % i) for i in range(PAGE)]
choice_links.append(link(PAGE, PAGE, "ds_chcnext"))   # pager, gated by next-page check
choice_links.append(link(PAGE + 1, PAGE + 1, ""))      # cancel always shows

choice_entry = {
    "__struct_id": 0,
    "Animation": dw(0), "AnimLoop": by(1),
    "Comment": cs("E_DS_CHOICE"),
    "Delay": dw(4294967295),
    "Quest": cs(""),
    "RepliesList": lst(choice_links),
    "Script": rs(""),
    "Sound": rs(""),
    "Text": loc("<CUSTOM5400>"),
}

choice_dlg = {
    "__data_type": "DLG ",
    "DelayEntry": dw(0),
    "DelayReply": dw(0),
    "EndConverAbort": rs("ds_chend"),    # closed/aborted -> plugin re-pops after a delay
    "EndConversation": rs("ds_chend"),   # (distinguishes abort from answered in C#)
    "EntryList": lst([choice_entry]),
    "NumWords": dw(0),
    "PreventZoomIn": by(1),
    "ReplyList": lst(choice_replies),
    "StartingList": lst([{"__struct_id": 0, "Active": rs(""), "Index": dw(0)}]),
}
with open(os.path.join(ROOT, "ds_choice.dlg.json"), "w") as f:
    json.dump(choice_dlg, f, indent=2)

print("wrote", os.path.join(ROOT, "ds_facedown.utp.json"))
print("wrote", os.path.join(ROOT, "ds_attack.dlg.json"))
print("wrote", os.path.join(ROOT, "ds_choice.dlg.json"))
