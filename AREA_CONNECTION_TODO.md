# Area Connection TODO — Phase 3

Remaining inaccessible areas (non-DM) to be connected to the main world.
Generated 2026-05-30. DM areas (dmhq, dmcloningchamber, dmcontrolroom, dmeventarea, prison, area024) are intentionally excluded.

---

## One-Way Exits (add reverse transition only)

These areas already have an outgoing transition to a reachable area, but the reachable area has no return path.
Fix: add a trigger or door to the anchor area's `.git.json` pointing back.

| Resref | Name | Outgoing → Anchor | Fix |
|---|---|---|---|
| `moriagateeast` | Moria Gate (East) | → `silverlodestream` (Sîr Ninglor) | Add trigger in `silverlodestream.git.json` LinkedTo = new waypoint in `moriagateeast` |
| `sharkeyschamber` | Sharkey's Chamber | → `sharkeysmill` (Sharkey's Mill) | Add door in `sharkeysmill.git.json` LinkedTo = `sharkeyschamber` door tag |
| `thealtar` | The Altar | → `theloft` (The Loft) | Add door in `theloft.git.json` LinkedTo = `thealtar` door tag |

---

## Fully Isolated Areas (add entry + return)

These have zero transitions. Require: new door/trigger in an anchor area, and a matching return transition inside.

### Moria

| Resref | Name | Suggested Anchor | Rationale |
|---|---|---|---|
| `area020` | Moria - Deep Caverns | Deepest reachable Moria level (check `area_graph.json` for the bottom of the Moria chain) | Extension of the Moria dungeon |

### Fornost / Northern Ruins

| Resref | Name | Suggested Anchor | Rationale |
|---|---|---|---|
| `area004` | Fornost (West) | Nearest reachable Fornost/Annuminas area (check `area_index.json` for "Fornost" or "Annuminas") | Main western ruins section |
| `fornostrangerway` | Fornost (Ranger Waystation) | `area004` (chain: connect `area004` first, then connect `fornostrangerway` off it) | Small outpost in the ruins |

### Shire

| Resref | Name | Suggested Anchor | Rationale |
|---|---|---|---|
| `shirebilbohouse` | Bilbo's House | Nearest reachable Shire area (check `area_index.json` for "Hobbiton" or "Shire") | Interior of Bag End |

### Mordor / Evil Faction Areas

| Resref | Name | Suggested Anchor | Rationale |
|---|---|---|---|
| `area010` | Temple of Nazgul | Nearest reachable Mordor or Minas Morgul area | Evil shrine; thematic fit with Mordor cluster |
| `nazgulguildhouse` | House of Nazgûl | `area010` once it's connected (chain via it) | Interior belonging to same evil cluster |

### Harad

| Resref | Name | Suggested Anchor | Rationale |
|---|---|---|---|
| `harad` | Northern Harad | Nearest reachable southern area (check `area_index.json` for areas near Gondor/Mordor southern border) | Southern realm; needs a desert/road transition |

### Tombs and Burial Sites

| Resref | Name | Suggested Anchor | Rationale |
|---|---|---|---|
| `tombofbbb` | Tomb of Badar, Badir, and Banir | Nearest reachable graveyard or ruins area | Dwarvish or Gondorian tomb |
| `tombofearendur` | Tomb of Earendur | Nearest reachable Arnor/Angmar ruins area | Old kingdom tomb |
| `tombofzoravor` | Tomb of Zoravor and Panavor | Nearest reachable ruins area | Unknown — check area contents before connecting |
| `gravesofthelostk` | Tombs of the Lost Souls | Nearest reachable graveyard or Barrow-downs area | Atmospheric haunted site |

### Special / Planar

| Resref | Name | Suggested Anchor | Rationale |
|---|---|---|---|
| `planeoftherender` | Plane of the Render | A dedicated portal area or via `houseofdispai001` NPC menu | Planar area; may require a quest gate |
| `houseofdispai001` | House of Homer | Add a reachable-world trigger in a central hub (e.g. Well of Eru or Rivendell) | Homer's teleport hub; currently only accessible via direct NPC invocation; giving it a world entry makes it an in-world location |

---

## Implementation Notes

- For each fix: use `bin/place-helper.py <resref> --suggest` to pick clear placement coordinates.
- Trigger pattern (used by most outdoor transitions): `newtransition` TemplateResRef, `LinkedTo = <waypoint_tag>`, `LinkedToFlags = 2`.
- Door-to-door pattern: `LinkedTo = <door_tag>`, `LinkedToFlags = 1`.
- Always update both `.git.json` AND `.gic.json` in sync (one GIC entry per new instance).
- After each set of fixes: run `nwn-manager repack` then `bin/refresh-homers-lotr-wiki` and check `module-index/area_paths.json` to confirm areas are no longer listed as unreachable.
