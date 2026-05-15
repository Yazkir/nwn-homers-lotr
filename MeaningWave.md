# MeaningWave — Developer Notes

Player-facing guide lives at `docs/manual/MeaningWave.html`.
This file covers implementation details, script locations, and maintenance tasks.

## Quick reference

| NPC | Blueprint resref | Waypoint tag | Area resref |
|-----|-----------------|--------------|-------------|
| Jordan Peterson | `mw_peterson_w` | `MW_SPAWN_PETERSON` | `rivendellupperha` |
| Alan Watts | `mw_watts_w` | `MW_SPAWN_WATTS` | `oldforest001` |
| Joseph Campbell | `mw_campbell_w` | `MW_SPAWN_CAMPBELL` | `balinstomb` |
| Terence McKenna | `mw_mckenna_w` | `MW_SPAWN_MCKENNA` | `northernforestso` |
| Jocko Willink | `mw_jocko_w` | `MW_SPAWN_JOCKO` | `helmsdeep001` |
| Carl Jung | `mw_jung_w` | `MW_SPAWN_JUNG` | `cryptsofthelosts` |
| Marcus Aurelius | `mw_aurelius_w` | `MW_SPAWN_AURELIUS` | `gwaththrone` |
| Akira the Don | `mw_akira` | — | `hallofleg` |

## Key scripts

- **`mw_spawn.nss`** — called from `onmoduleload.nss`; spawns each wandering `_w` NPC at its
  waypoint tag. Add new `SpawnAtWaypoint` calls here for any new Meaningwave NPCs.
- **`mw_unlock_inc.nss`** — shared include for unlock state checks. Used by quiz dialogue
  conditionals and by the emote-wand summon logic.
- **`emotewand.dlg`** — contains the "[Summon a Legend.]" branch; conditionals gate each
  option on the matching unlock flag.
- **Dialogue resrefs** — each NPC has a `mw_<name>.dlg.json` with the five-question quiz tree
  and post-unlock content.

## Adding a new Meaningwave NPC

1. Create `mw_<name>.utc.json` (wandering blueprint) and `mw_<name>_w.utc.json` (placed world variant).
2. Add a `SpawnAtWaypoint("MW_SPAWN_<NAME>", "mw_<name>_w")` call in `mw_spawn.nss`.
3. Add `mw_<name>_w` to `creaturepalcus.itp.json` category index 11 (ID=116).
4. Place an `mw_spawn` waypoint in the target area (Waypoint palette → Custom 5) with
   Tag = `MW_SPAWN_<NAME>`.
5. Author `mw_<name>.dlg.json` with the five-question quiz and summon/henchman wiring.
6. Add the unlock flag check to `mw_unlock_inc.nss` and a new branch in `emotewand.dlg`.
7. Update `docs/manual/MeaningWave.html` with the player-facing location and path info.

## Regenerating path documentation

If new transitions are added to the module, regenerate paths with the `nwn-area-path`
tool that ships with `nwn-manager`:

```sh
# All guide paths (after `nwn-manager wiki` is up to date):
for area in rivendellupperha oldforest001 balinstomb northernforestso \
            helmsdeep001 cryptsofthelosts gwaththrone hallofleg; do
  echo "=== thewelloferu → $area ==="
  nwn-area-path thewelloferu "$area"
done

# Or pipe through JSON for tooling:
nwn-area-path --json thewelloferu rivendellupperha
```

The graph is built from the static wiki under `docs/areas/`. Doors and triggers are reliable
edges; conversation teleports (talk-NPCs like the Guardian of Light) are also captured.
Re-run `nwn-manager wiki` after adding new areas (like the Hall of Legends) so the graph
stays current.

The wiki extractor does **not** pick up placeable-OnUsed teleports (the Wayshrine of the Wave
is one), so those edges live in a hand-maintained side-car at `docs/area_edges_extra.json`.
Add `{"from","to","kind","label"}` objects there to declare any custom teleport that scripts
handle but the wiki misses.

## Hall of Legends — statue / unlock mechanic

Statues on unearned pedestals are converted to live figures via a script that checks
the unlock flags set in `mw_unlock_inc.nss`. See the Hall of Legends area and the
`hallofleg` conversation for the Akira reward ("Akira's Mixtape") trigger.
