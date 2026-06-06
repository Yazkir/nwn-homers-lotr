#!/usr/bin/env python3
"""Spawn-leash coverage check (build-time smoke test).

The anti-kiting "area leash" (unpacked/leash_to_area.nss) sends a creature back
to its spawn area if it is led out. That only works if the creature records a
"spawn" LocalLocation home at OnSpawn. This check enforces the invariant:

    every creature blueprint must EITHER
      - have a ScriptSpawn that stores "spawn" (directly or via ExecuteScript
        chain, e.g. x2_def_spawn -> nw_c2_default9), OR
      - opt out explicitly with local int NO_LEASH = 1.

A creature with a blank or non-storing OnSpawn and no opt-out is un-leashable
and fails the build, so the exploit can't silently return as content is added.

Scans unpacked/ directly (module-index/ is gitignored and may be absent on a
fresh clone). Exits 0 if all creatures pass, 1 otherwise (prints offenders).

Assumption: spawn storage is expressed as the literal
    SetLocalLocation(<self>, "spawn", ...)
which is the convention used throughout this module.
"""

import glob
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UNPACKED = os.path.join(ROOT, "unpacked")

STORE_RE = re.compile(r'SetLocalLocation\s*\([^;{}]*"spawn"')
EXEC_RE = re.compile(r'ExecuteScript\s*\(\s*"([^"]+)"')


def build_storing_set():
    """Return the set of script resrefs (lowercased) that store a "spawn" home,
    resolving ExecuteScript chains to a fixpoint."""
    direct = {}      # resref -> set(ExecuteScript targets)
    stores = set()
    for path in glob.glob(os.path.join(UNPACKED, "*.nss")):
        resref = os.path.basename(path)[:-4].lower()
        try:
            text = open(path, encoding="utf-8", errors="replace").read()
        except OSError:
            continue
        if STORE_RE.search(text):
            stores.add(resref)
        direct[resref] = {t.lower() for t in EXEC_RE.findall(text)}

    # Transitive closure: a script stores if it ExecuteScripts a storing script.
    changed = True
    while changed:
        changed = False
        for resref, targets in direct.items():
            if resref not in stores and targets & stores:
                stores.add(resref)
                changed = True
    return stores


def field_value(bp, key):
    v = bp.get(key)
    return v.get("value") if isinstance(v, dict) else None


def has_no_leash(bp):
    vt = bp.get("VarTable")
    rows = vt.get("value") if isinstance(vt, dict) else None
    if not isinstance(rows, list):
        return False
    for row in rows:
        if not isinstance(row, dict):
            continue
        name = field_value(row, "Name")
        if name == "NO_LEASH" and field_value(row, "Value"):
            return True
    return False


def main():
    storing = build_storing_set()
    failures = []
    total = 0
    for path in sorted(glob.glob(os.path.join(UNPACKED, "*.utc.json"))):
        total += 1
        resref = os.path.basename(path)[: -len(".utc.json")]
        try:
            bp = json.load(open(path, encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as e:
            failures.append((resref, f"<unreadable: {e}>"))
            continue
        script = (field_value(bp, "ScriptSpawn") or "").strip()
        if has_no_leash(bp):
            continue
        if script.lower() in storing:
            continue
        failures.append((resref, script or "<blank>"))

    if failures:
        print(f"[spawn-leash] FAIL: {len(failures)}/{total} creature blueprint(s) "
              f"neither store a spawn home nor set NO_LEASH=1:", file=sys.stderr)
        for resref, script in failures:
            print(f"  - {resref:<28} ScriptSpawn={script}", file=sys.stderr)
        print("\nFix each by giving it a spawn-storing OnSpawn (e.g. leash_spawn, "
              "x2_def_spawn, or add SetLocalLocation(OBJECT_SELF,\"spawn\","
              "GetLocation(OBJECT_SELF)) to its OnSpawn) or set local int "
              "NO_LEASH=1. See README 'Area leashing'.", file=sys.stderr)
        return 1

    print(f"[spawn-leash] OK: all {total} creature blueprints are leash-covered "
          f"or NO_LEASH-exempt.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
