#!/usr/bin/env python3
"""Phase 1 automated typo fixes for .dlg.json conversation files.

Conservative: only fixes patterns that are unambiguously wrong, not intentional
NPC dialect (missing apostrophes, simplified grammar, slang).
"""
import glob
import json
import re
import sys
from pathlib import Path

UNPACKED = Path(__file__).parent.parent / "unpacked"

# (compiled_pattern, replacement, description)
FIXES = [
    (re.compile(r'\bteh\b'), 'the', 'teh→the'),
    (re.compile(r'\balchahol\b', re.IGNORECASE), 'alcohol', 'alchahol→alcohol'),
    # Double period NOT part of an ellipsis (not preceded or followed by another dot)
    (re.compile(r'(?<!\.)\.\.(?!\.)'), '...', '..→...'),
    # Multiple spaces → single space
    (re.compile(r'  +'), ' ', 'multi-space→single'),
    # Space before punctuation
    (re.compile(r' +([.,!?;:])'), r'\1', 'space-before-punct'),
]


def fix_text(text: str) -> tuple[str, list[str]]:
    """Apply all fixes to a text string. Returns (fixed_text, list_of_changes)."""
    changes = []
    for pattern, replacement, desc in FIXES:
        new_text = pattern.sub(replacement, text)
        if new_text != text:
            changes.append(f"  [{desc}] {text!r} → {new_text!r}")
            text = new_text
    return text, changes


def fix_entry_list(entries: list, all_changes: list, filename: str) -> bool:
    """Fix text in a list of dialogue entries (EntryList or ReplyList). Returns True if any changed."""
    changed = False
    for entry in entries:
        text_field = entry.get("Text")
        if not text_field:
            continue
        if not isinstance(text_field, dict):
            continue
        val = text_field.get("value")
        if not isinstance(val, dict):
            continue
        if "0" not in val:
            continue
        original = val["0"]
        if not isinstance(original, str):
            continue
        fixed, changes = fix_text(original)
        if changes:
            val["0"] = fixed
            all_changes.append(f"{filename}:")
            all_changes.extend(changes)
            changed = True
    return changed


def main():
    dlg_files = sorted(UNPACKED.glob("*.dlg.json"))
    total_files = len(dlg_files)
    changed_files = 0
    all_changes: list[str] = []

    for dlg_path in dlg_files:
        with open(dlg_path) as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError as e:
                print(f"ERROR: could not parse {dlg_path.name}: {e}", file=sys.stderr)
                continue

        file_changes: list[str] = []
        file_changed = False

        for list_key in ("EntryList", "ReplyList"):
            entry_list = data.get(list_key)
            if not entry_list:
                continue
            entries = entry_list.get("value", [])
            if fix_entry_list(entries, file_changes, dlg_path.name):
                file_changed = True

        if file_changed:
            with open(dlg_path, "w") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
                f.write("\n")
            changed_files += 1
            all_changes.extend(file_changes)

    print(f"\nScanned {total_files} files, changed {changed_files}.\n")
    if all_changes:
        print("Changes made:")
        for line in all_changes:
            print(line)
    else:
        print("No changes.")


if __name__ == "__main__":
    main()
