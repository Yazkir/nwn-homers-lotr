# Dungeon Solitaire — NWN integration (`DungeonSolitaire.Nwn`)

An in-process [Anvil](https://nwn-dotnet.github.io/Anvil/) plugin that runs the
`DungeonSolitaire.Core` C# card game inside the NWN module, in the prepped area
**`area017`** ("Dungeon Solitaire"). Cards are portrayed by NWN creatures and
statues instead of sprites; players read a card by **examining** the figure.

## How it plays

1. A player pulls the **DS_NewGame** lever and becomes the *active player*.
2. The board renders: five enemy columns at the `DS_C{col}_R{row}` waypoints
   (face-down cards are statues, revealed cards are named NPCs) and the player's
   hand of ally NPCs lined up around `DS_Hand` (they spawn at `DS_Hand_SPAWN` and
   walk in).
3. Each turn the player **clicks an ally**, which opens the `ds_attack`
   conversation to pick a target column (or "unleash" for area effects). The ally
   lunges, VFX play, the front enemy takes damage / dies / reveals the next card.
4. Win by clearing every column; lose if you run out of allies. The score is
   written to the **DS_HighScore** gravestone and persisted.
5. Bystanders may watch but cannot act. If the active player leaves the area or
   logs out for 30 s, the board clears and the next lever-puller takes over.

## Architecture

| File | Role |
|------|------|
| `DsManager.cs` | Anvil service: wires the lever, gates bystanders, owns the single session, clears the board on abandonment, hosts the `ds_attack` conversation script handlers. |
| `DsSession.cs` | One live game: runs the blocking `GameEngine` on a background thread and marshals its `GameEventBus` events onto the main thread; drives the effect-pacing / input handshake and the attack flow. |
| `MainThreadDispatcher.cs` | Serializes engine-thread work onto Anvil's main thread (the NWN analogue of Godot's `CallDeferred`). |
| `BoardView.cs` / `CardActor.cs` | Reconcile engine state to spawned statues/creatures; spawn, reveal, reposition, lunge. |
| `CardCreatureMap.cs` | Card → creature blueprint resref (real matches + Old-Tagget placeholders) and the examine-description text. |
| `Vfx.cs` / `DsConfig.cs` | Effect→VFX map and the area/tag/timing constants (timings ported from the Godot front-end). |
| `HighScoreStore.cs` | Persists results to JSON under the server plugin-data dir and renders the gravestone description. |

The threading model mirrors `Dungeon-Solitaire.Godot` exactly: the engine blocks
on `RunTurn()`/`SubmitInput`/`AcknowledgeEffect`; we never block Anvil's main
thread, and only read engine collections at points where the engine thread is
provably parked (SelectAlly, paced effect beats, turn-end, game-over).

## Build

```bash
dotnet build csharp/DungeonSolitaire.Nwn -c Release
```

`NWN.Anvil` is pinned to **8193.37.3** in the `.csproj` — bump it to match your
`nwnxee/unified` image's NWN build if needed.

## Deploy (server runs the `nwnxee/unified` container)

1. Ensure the server boots the Anvil managed host (the unified image's NWNX_DotNET
   plugin loading Anvil). Anvil plugins live under `<server-home>/anvil/Plugins/`.
2. Copy the build output into a plugin folder:
   ```bash
   DEST=~/.local/state/nwnxee-homer/anvil/Plugins/DungeonSolitaire
   mkdir -p "$DEST"
   cp bin/Release/net8.0/DungeonSolitaire.Nwn.dll  "$DEST"/
   cp bin/Release/net8.0/DungeonSolitaire.Core.dll "$DEST"/
   ```
3. Repack the module so the new GFF assets ship in it:
   ```bash
   nwn-manager repack
   ```
   New module resources: `ds_facedown.utp` (statue), `ds_attack.dlg`
   (column-pick conversation), and the updated `area017` placeable descriptions.
   The dialog's `ds_atk*` scripts are handled by the plugin's `[ScriptHandler]`
   methods — there are no `.nss` files for them, and none are needed.
4. Restart `nwnxee-homer`; watch `~/.local/state/nwnxee-homer/logs.0/` for the
   `[DungeonSolitaire] wired Dungeon Solitaire area and lever.` line.

## Regenerating the GFF assets

`ds_facedown.utp.json` and `ds_attack.dlg.json` are emitted by:

```bash
python3 csharp/DungeonSolitaire.Nwn/gen_gff.py
```

## Known limitations (vertical slice)

- Secondary, effect-driven choices (discard / pick-a-target / effect ordering)
  currently auto-resolve to the first option so games always complete; only the
  core ally→column attack choice has a conversation UI.
- Column whittling snaps enemy NPCs forward (no walk) when the front card dies;
  the ally lunge and hand rally are the animated beats.
- Replacing Old-Tagget placeholders (Frodo, Merry, Pippin, Eomer, Lurtz, Grima)
  with bespoke blueprints is future work — see `dungeon-solitaire.txt`.
