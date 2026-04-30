# Homer's LOTR VEL v3 — module source

This is an **unpacked Neverwinter Nights 1 (Enhanced Edition) module**, kept in
text form so it can be diffed in git and edited by hand or by an LLM. The
binary `.mod` is built from `unpacked/` on demand.

The module itself ("Legendary LotR" / "Homer's Quest's LOTR") is a Tolkien-themed
persistent-world style adventure built on **CEP 2** (Community Expansion Pack).
It targets NWN ≥ 1.68 and uses a custom TLK named `cep`.

## Workflow at a glance

```
nwn-manager unpack   →  reads NWN modules folder (path stored in
                         .nasher/source), fills unpacked/ from the .mod
                         (overwrites unpacked/ — round-trip is destructive)

edit unpacked/       →  JSON for GFF resources, .nss for scripts
                         commit changes to git as you go

nwn-manager repack   →  builds unpacked/ → dist/<name>.mod, copies into
                         the NWN modules folder
                         (script compilation happens here, errors will surface)

nwn-manager wiki     →  generates a static HTML wiki under wiki/
                         (gitignored; rebuild explicitly when you want it)
```

`nwn-manager` lives in the separate [nwn_manager](https://github.com/...) repo
and wraps `nasher` + `nwn_gff` + `nwn_script_comp` (from `niv/neverwinter.nim`).

**Source of truth is `unpacked/` + git.** Don't hand-edit the `.mod`; it'll be
overwritten next repack.

### Build artifacts (gitignored, do not commit)

- `dist/` — packed `.mod` output
- `wiki/` — generated HTML wiki
- `.nasher/` — nasher's working cache + recorded source path (`.nasher/source`)
- `*.ncs` — compiled scripts; only `.nss` source belongs in git

## Source tree (`unpacked/`)

`nasher.cfg` flattens everything into `unpacked/` — there is no `areas/`,
`creatures/`, etc. subdirectory. Resources are distinguished by extension. As
of the initial unpack: 7281 files, ~5000 JSON blueprints + 2340 scripts.

| Pattern              | What it is                                              | Approx count |
|----------------------|---------------------------------------------------------|--------------|
| `module.ifo.json`    | Module config: areas list, event hooks, HAKs, TLK       | 1            |
| `module.jrl.json`    | Journal — quest categories and entries                  | 1            |
| `repute.fac.json`    | Faction list + reputation matrix                        | 1            |
| `<name>.are.json`    | Area static data (tiles, weather, lighting, scripts)    | 287          |
| `<name>.git.json`    | Area "GIT" — placed instances of creatures/doors/etc    | 287          |
| `<name>.gic.json`    | Area instance comments (parallel to .git, comments only)| 287          |
| `<name>.utc.json`    | Creature blueprint                                      | 552          |
| `<name>.uti.json`    | Item blueprint                                          | 2990         |
| `<name>.utd.json`    | Door blueprint                                          | 4            |
| `<name>.utp.json`    | Placeable blueprint                                     | 49           |
| `<name>.utw.json`    | Waypoint blueprint                                      | 49           |
| `<name>.utm.json`    | Merchant/Store blueprint                                | 23           |
| `<name>.utt.json`    | Trigger blueprint                                       | 9            |
| `<name>.ute.json`    | Encounter blueprint                                     | 81           |
| `<name>.dlg.json`    | Conversation/dialogue tree                              | 309          |
| `<type>palcus.itp.json` | Custom toolset palette (creature/door/item/etc)      | 9            |
| `<name>.nss`         | NWScript source                                         | 2340         |
| `_0ptm.ptm`          | Legacy plot-manager file (binary, mostly empty)         | 1            |

A blueprint's filename **is** its ResRef (e.g. `bree.are.json` → ResRef `bree`).
Areas are 1:1:1 between `.are` (static), `.git` (instances), and `.gic` (per-instance
comments) — keep all three when renaming or deleting an area.

## GFF-as-JSON format

`nwn_gff` round-trips between binary GFF and a typed JSON shape. Every leaf
value is wrapped in `{"type": "<gff-type>", "value": ...}`:

```jsonc
{
  "__data_type": "UTC ",                          // top-level resource type tag
  "Tag":          { "type": "cexostring", "value": "MyNPC" },
  "Str":          { "type": "byte",       "value": 14 },
  "HitPoints":    { "type": "short",      "value": 25 },
  "ChallengeRating": { "type": "float",   "value": 1.0 },
  "TemplateResRef":  { "type": "resref",  "value": "myresref" },
  "FirstName":    { "type": "cexolocstring",
                    "value": { "0": "Aragorn" } },     // 0 = English string
  "Description":  { "type": "cexolocstring",
                    "value": { "id": 12677 } },        // TLK ref, looks up cep.tlk
  "ClassList":    { "type": "list",                    // lists hold structs
                    "value": [
                      { "__struct_id": 2,
                        "Class":      { "type": "int",   "value": 12 },
                        "ClassLevel": { "type": "short", "value": 1  } }
                    ] }
}
```

### Key conventions

- **`__data_type`** — 4-char resource tag at the root: `"UTC "`, `"UTI "`,
  `"UTD "`, `"UTP "`, `"UTW "`, `"UTM "`, `"UTT "`, `"UTE "`, `"ARE "`,
  `"GIT "`, `"GIC "`, `"DLG "`, `"JRL "`, `"FAC "`, `"IFO "`, `"ITP "`. The
  trailing space is significant.
- **`__struct_id`** — appears on every struct that lives inside a list.
  Sometimes used by the engine as a tag (e.g. inventory slots in
  `Equip_ItemList`: 8 = right hand, 16 = left hand, 2048 = creature hide).
  Don't invent new struct IDs unless you know what they mean — copy from a
  similar entry.
- **GFF primitive types** — `byte` (u8), `char` (i8), `word` (u16),
  `short` (i16), `dword` (u32), `int` (i32), `dword64`, `int64`, `float`,
  `double`, `cexostring` (UTF-8 string), `cexolocstring`, `resref`, `list`,
  `struct`, `void` (binary blob, base64-encoded if it ever appears).
- **`resref`** — max **16 characters**, lowercase, used as the in-game
  filename. Must be unique per resource type. Verify with sampling: every
  blueprint in this module has `len(TemplateResRef) <= 16`. Filenames must
  match: `myresref.utc.json` → `TemplateResRef: myresref`.
- **`Tag` / `cexostring`** — up to 32 characters. Tags identify *instances*
  at runtime via `GetObjectByTag`; multiple instances can share a tag. Tags
  are case-sensitive in script lookups.
- **`cexolocstring`** — keys in `value` are language IDs:
  `0`=EN, `1`=FR, `2`=DE, `3`=IT, `4`=ES, `5`=PL, `6`=KO, `7`=zh-CN.
  An `"id"` key is a **StrRef** into the TLK file (here, `cep.tlk`). Either
  is valid; if both are present the inline string wins for that language.
  For new content, the simplest path is `{"0": "English text"}` only.
- **Empty `cexolocstring`** is `{ "type": "cexolocstring", "value": {} }`.
- Field-key order in JSON does not matter to nwn_gff; it sorts keys
  case-insensitively on output.

## Module config — `module.ifo.json`

The single most important file. Holds the area list, every module-level
event hook, HAK list, custom TLK reference, entry point, etc.

### Module event hooks (current wiring)

| Field             | Script             | Notes                                |
|-------------------|--------------------|--------------------------------------|
| `Mod_OnHeartbeat` | `bleeding`         | Custom bleed-out / death-at-negative |
| `Mod_OnModLoad`   | `pc_export_inc`    | PC autosave init                     |
| `Mod_OnClientEntr`| `hgll_cliententer` | Letoscript apply on enter (HGLL)     |
| `Mod_OnClientLeav`| `hgll_client_exit` |                                      |
| `Mod_OnAcquirItem`| `acquireditem_tag` | Hooks into Bedlamson Dynamic Merchants |
| `Mod_OnUnAqreItem`| `deathamuletdecay` | "deathamulet" cleanup                |
| `Mod_OnActvtItem` | `dmfi_activate`    | DM Friendly Initiative item          |
| `Mod_OnPlrDeath`  | `ondeath020`       |                                      |
| `Mod_OnPlrDying`  | `mod_dying`        |                                      |
| `Mod_OnPlrLvlUp`  | `mod_level`        |                                      |
| `Mod_OnPlrRest`   | `on_mod_rest`      |                                      |
| `Mod_OnSpawnBtnDn`| `mod_respawn`      | Player respawn-button handler        |

Available but unused: `Mod_OnModStart`, `Mod_OnPlrEqItm`,
`Mod_OnPlrUnEqItm`, `Mod_OnCutsnAbort`, `Mod_OnUsrDefined`.

### Other module fields worth knowing

- `Mod_Entry_Area` = `thewelloferu` (entry point: `Mod_Entry_X/Y/Z` and
  `Mod_Entry_Dir_X/Y`).
- `Mod_HakList` = the eight CEP 2 HAKs. Custom haks would go here.
- `Mod_CustomTlk` = `cep`. Numeric `id` in any cexolocstring resolves
  against `cep.tlk` via NWN's TLK lookup.
- `Mod_XPScale` = `150` (1.5×).
- `Mod_StartHour` / `Mod_DawnHour` / `Mod_DuskHour` / `Mod_MinPerHour` —
  in-game time config.
- `Mod_Area_list` — list of every area's ResRef. **Adding or removing an
  area requires updating this list.** The engine uses it to enumerate areas
  on load.
- `Mod_CacheNSSList` — scripts the engine should pre-cache. Most additions
  don't need this; only specific event/include scripts that benefit from
  early load are listed here.

## Resource shapes (cheat sheet for edits)

When adding or modifying a blueprint, copy a similar existing file and
mutate it. Don't try to write one from scratch — the engine is fussy about
field presence and `__struct_id` values.

### Area (`<name>.are.json` / `<name>.git.json` / `<name>.gic.json`)

- `.are.json` — static area data: `Tileset` (resref like `ttr01`),
  `Width`/`Height` in tiles, `Tile_List` (one struct per tile;
  `Tile_ID`, `Tile_Orientation`, lighting), event scripts (`OnEnter`,
  `OnExit`, `OnHeartbeat`, `OnUserDefined`), weather, lighting, fog,
  day/night colors. `ResRef` and `Tag` must be present.
- `.git.json` — Game Instance Tracking. Lists every placed creature, door,
  encounter, placeable, sound, store, trigger, waypoint. Each instance is
  a struct with `XPosition`, `YPosition`, `ZPosition`, `XOrientation`,
  `YOrientation`, plus the embedded blueprint fields. Top-level
  `AreaProperties` holds music/ambient sound IDs.
- `.gic.json` — parallel comment list, one entry per instance, in the
  same order as `.git`. Don't reorder one without the other.

### Creature (`<name>.utc.json`, type `UTC`)

Key fields: `TemplateResRef` (matches filename), `Tag`, `FirstName`,
`LastName`, `Appearance_Type` (model row from `appearance.2da`),
`PortraitId`, ability scores (`Str`/`Dex`/`Con`/`Int`/`Wis`/`Cha`,
all `byte`), `HitPoints` / `MaxHitPoints` / `CurrentHitPoints` (`short`),
`ClassList` (list of `{ Class, ClassLevel }`), `FactionID`, `Race`,
`Gender`, `GoodEvil`, `LawfulChaotic`, `Conversation` (resref of a
`.dlg`), `Equip_ItemList`, `ItemList` (inventory), `SkillList`,
`FeatList`, and the 13 `Script*` fields below.

**Standard creature event scripts.** This module mixes the NW1 default
set (`nw_c2_default*`) with the X2/HotU set (`x2_def_*`). Use whichever
the surrounding similar creatures use; both ship with NWN:EE.

| Script field        | NW1 default       | X2/HotU default      |
|---------------------|-------------------|----------------------|
| `ScriptHeartbeat`   | `nw_c2_default1`  | `x2_def_heartbeat`   |
| `ScriptOnNotice`    | `nw_c2_default2`  | `x2_def_percept`     |
| `ScriptEndRound`    | `nw_c2_default3`  | `x2_def_endcombat`   |
| `ScriptDialogue`    | `nw_c2_default4`  | `x2_def_onconv`      |
| `ScriptAttacked`    | `nw_c2_default5`  | `x2_def_attacked`    |
| `ScriptDamaged`     | `nw_c2_default6`  | `x2_def_ondamage`    |
| `ScriptDeath`       | `nw_c2_default7`  | `x2_def_ondeath`     |
| `ScriptDisturbed`   | `nw_c2_default8`  | `x2_def_ondisturb`   |
| `ScriptSpawn`       | `nw_c2_default9`  | `x2_def_spawn`       |
| `ScriptRested`      | `nw_c2_defaulta`  | `x2_def_rested`      |
| `ScriptSpellAt`     | `nw_c2_defaultb`  | `x2_def_spellcast`   |
| `ScriptUserDefine`  | `nw_c2_defaultd`  | `x2_def_userdef`     |
| `ScriptOnBlocked`   | `nw_c2_defaulte`  | `x2_def_onblocked`   |

Common module-specific overrides: `ScriptDeath` is often `staticspawn`,
`gpondeath`, or a per-quest script (e.g. `dolguldurshout`).

### Item (`<name>.uti.json`, type `UTI`)

Key fields: `TemplateResRef`, `Tag`, `LocalizedName`, `Description`,
`BaseItem` (row in `baseitems.2da` — e.g. 16 = half plate, 70 = leather
boots, 113 = arrow), `Cost`, `StackSize`, `PropertiesList`, color slots
(`Cloth1Color`/`Metal1Color`/`Leather1Color`/etc), and for armor the
20 `ArmorPart_*` fields (model parts like `ArmorPart_Belt`,
`ArmorPart_LBicep`, etc).

`PropertiesList` entries describe item properties (enhancement bonuses,
spell resistance, on-hit effects, etc):

```jsonc
{ "__struct_id": 0,
  "PropertyName": { "type": "word", "value": 1   },  // itempropdef.2da row
  "Subtype":      { "type": "word", "value": 0   },  // depends on PropertyName
  "CostTable":    { "type": "byte", "value": 2   },  // iprp_costtable.2da row
  "CostValue":    { "type": "word", "value": 5   },  // index into that table
  "Param1":       { "type": "byte", "value": 255 },  // 255 = unused
  "Param1Value":  { "type": "byte", "value": 0   },
  "ChanceAppear": { "type": "byte", "value": 100 } }
```

### Door / Placeable / Trigger / Encounter / Waypoint / Store

All follow the same pattern as creatures: a `TemplateResRef`, a `Tag`,
typed fields, and event-script `resref` fields. Defaults to copy:

- **Doors** (`UTD`): `OnDeath` → `x2_door_death`, `OnSpellCastAt` → `close_door_fast`.
- **Placeables** (`UTP`): event scripts default to empty unless interactive.
- **Triggers** (`UTT`): `ScriptOnEnter`/`ScriptOnExit`/`ScriptHeartbeat`/`ScriptUserDefine`.
- **Encounters** (`UTE`): `OnEntered`/`OnExit`/`OnExhausted`/`OnHeartbeat`/`OnUserDefined`,
  plus `CreatureList` (what spawns) and `MaxCreatures`/`Difficulty`.
- **Waypoints** (`UTW`): no event scripts. Walk-path waypoints are tagged
  `WP_<creature_tag>_NN` and used by `WalkWayPoints()`.
- **Stores** (`UTM`): `StoreList` of struct IDs 0..4 = the five inventory
  pages (Armor, Misc, Potions, Rings, Weapons in CEP layout). `MarkUp`/
  `MarkDown` are buy/sell percentages; `MaxBuyPrice` caps individual
  buys; `BlackMarket=1` enables stolen-goods handling.

### Conversation (`<name>.dlg.json`, type `DLG`)

Three parallel lists held at the root, plus a `StartingList`:

- **`StartingList`** — links into `EntryList`. The engine evaluates each
  `Active` (a `StartingConditional` script) in order and shows the first
  whose conditional passes (or the first with no conditional).
- **`EntryList`** — what the **NPC** says. Each entry has a `Text`
  (locstring), an optional `Sound`, `Animation`, `Quest`, and a per-node
  `Script` (action: `void main()` that runs when this node fires). Its
  `RepliesList` links into `ReplyList`.
- **`ReplyList`** — what the **PC** can pick. Same fields as Entry plus
  an `EntriesList` linking back into `EntryList` for the next NPC line.
  An empty `EntriesList` ends the conversation.

Links carry the conditional, the targets carry the action — schematically:

```
StartingList[i].Active   → StartingConditional (gates whether entry shows)
StartingList[i].Index    → EntryList[Index]
EntryList[i].Script      → action script (runs when NPC line shown)
EntryList[i].RepliesList[j].Active → conditional (gates the PC choice)
EntryList[i].RepliesList[j].Index  → ReplyList[Index]
ReplyList[k].Script      → action script (runs when PC line picked)
ReplyList[k].EntriesList[l].Index → next EntryList[Index]
```

`Index` values are 0-based positions in the sibling list. **Renumbering
or deleting an entry/reply re-indexes everyone**: when removing a node,
patch every `Index` in every link list that refers to a higher position.
Easier to leave dead nodes in place than to compact.

`EndConverAbort` and `EndConversation` at the root are scripts that run
when the conversation ends naturally / is interrupted (commonly
`nw_walk_wp` to resume a waypoint patrol).

Convention in this module:
- Action scripts: `at_NNN.nss` (numeric, e.g. `at_054`) — auto-named by
  the toolset's script wizard; OK to author yours with a descriptive name.
- Conditional scripts: any name; signature must be `int StartingConditional()`
  returning `TRUE`/`FALSE`. Many use the `dmfi_univ_cond` family with
  parameters set on local variables.

### Journal (`module.jrl.json`)

`Categories` is a list of quests; each quest has a `Tag` (string used by
`AddJournalQuestEntry`), a `Name`, `Priority`, `XP`, and an `EntryList`
of entry stages (`ID` = stage number passed to `AddJournalQuestEntry`,
`End=1` marks final stage).

### Faction (`repute.fac.json`)

`FactionList` holds factions in struct-id order — referenced from
`UTC.FactionID`. The first four are the engine-required PC/Hostile/
Commoner/Merchant/Defender. `RepList` is a flat list of pairwise
reputations (`FactionID1`, `FactionID2`, `FactionRep` 0–100).

### Palette files (`*palcus.itp.json`)

These are the toolset's custom-blueprint palettes, one per category
(creature/door/encounter/item/placeable/sound/store/trigger/waypoint).
Editing them affects only the in-toolset categorization, never gameplay.
Safe to ignore unless you specifically want to tidy the palette tree.

## NWScript (`*.nss`)

NWScript is the in-engine scripting language. Files compile to `.ncs` at
pack time; only `.nss` source belongs in git.

### Script entry-point conventions

- **Event scripts**: `void main() { … }` — no return.
- **Dialogue conditionals**: `int StartingConditional() { … return TRUE/FALSE; }`.
- **Tag-based item events** (used in this module via the Bedlamson
  Dynamic Merchant System hookups): functions with reserved names like
  `OnAcquireItem`, called via the X2 `nw_o2_coninclude` dispatcher.
- **Includes**: `#include "<name_without_ext>"` — pulls in another
  `.nss`. Cyclic includes are a compile error; nasher follows include
  chains for incremental rebuilds.

### Module-specific framework prefixes

The module pulls in several established NWN frameworks. Treat their
files as **third-party — don't refactor unless you know the framework**.

| Prefix     | What it is                                     | Notes                     |
|------------|------------------------------------------------|---------------------------|
| `nw_*`     | BioWare base game (NW1) defaults               | Available in CEP/base; don't ship modified copies |
| `x0_* x2_* x3_*` | BioWare expansion defaults (HotU)         | Same                      |
| `zep_*`    | Z-PEP placeable / creature pack helpers        |                           |
| `dmfi_*`   | DM Friendly Initiative (DM tools, dice, dialog tokens) | `dmfi_univ_1..N` are universal action scripts; `dmfi_univ_cond` is a parameterized conditional |
| `dmw_*`    | DM Wand utilities                              |                           |
| `bdm_*`    | Bedlamson's Dynamic Merchants (faction/race-restricted store stocks) | Hooks `OnAcquireItem` |
| `hgll_*`   | Homer's Game Legendary Levels (Letoscript-based level 41–60) | Edit constants in `hgll_const_inc.nss`; uses external Letoscript on the server |
| `pc_export*` | PC autosave on heartbeat                     | Hooked at `Mod_OnModLoad` |

`hgll_const_inc.nss` contains a hard-coded **Windows path**
(`C:/NeverwinterNights/NWN/servervault/`) for Letoscript — leave the
constant alone unless you actually want to enable Letoscript on this server.

### Persistence

The module does NOT use NWNX. Persistence is via:

- `GetLocalInt/Float/String/Object` — per-object scratch state,
  cleared on object destruction or area cleanup.
- `GetCampaignInt/Float/String` — persistent across sessions
  (campaign DB, e.g. the `bankdb` campaign for the in-module bank).
- `pc_export_inc` autosave — periodic per-PC save via the engine's
  `ExportSingleCharacter` hook.

There is no SQL — `GetCampaignInt`-style functions persist to NWN's
campaign database files in `database/<campaign>.bdb`.

## Common edit recipes

### Modify an existing NPC's stats / appearance

1. Find the blueprint: `<resref>.utc.json` in `unpacked/`.
2. Edit the field directly (e.g. `Str.value`, `MaxHitPoints.value`,
   `Appearance_Type.value`).
3. **Note**: `.utc.json` is the *blueprint*. Existing instances in
   `<area>.git.json` carry a copy of the blueprint fields and won't
   automatically pick up changes. To update placed instances too, also
   patch the embedded creature struct inside `<area>.git.json`'s
   `Creature List`. Easiest way for many areas: re-place from the
   palette in the toolset, or script a JSON patch.
4. Repack and test in-game.

### Add a new NPC creature

1. Pick a unique resref ≤ 16 chars (e.g. `myorc01`). Verify nothing else
   in `unpacked/` uses it: `ls unpacked/myorc01.*`.
2. Copy a similar `.utc.json` to `myorc01.utc.json`. Edit
   `TemplateResRef`, `Tag`, `FirstName`/`LastName`, ability scores,
   `ClassList`, `Appearance_Type`, `Conversation`, scripts, equipment.
3. To place an instance in an area, append a struct to that area's
   `<area>.git.json` `Creature List` with the embedded blueprint copy
   plus `XPosition`/`YPosition`/`ZPosition`/`XOrientation`/`YOrientation`,
   then add a matching empty `Comment` struct to `<area>.gic.json`'s
   `Creature List`. (Keeping `.git` and `.gic` in sync by index matters.)
4. To make the NPC spawnable from script: leave it as a blueprint and
   spawn with `CreateObject(OBJECT_TYPE_CREATURE, "myorc01", lLoc)`.

### Add a new item

1. Pick a resref. Copy a similar `.uti.json` (one with the right `BaseItem`
   row).
2. Edit `TemplateResRef`, `Tag`, `LocalizedName`, `Description`, `Cost`,
   appearance fields, `PropertiesList`.
3. To put it in a creature's inventory or a chest, add an entry to the
   container's `ItemList` with `InventoryRes` = your resref.
4. Or spawn with `CreateItemOnObject("myitem", oTarget, 1);`.

### Add a new area

This is the most invasive change.

1. Build the area in the NWN:EE toolset (much easier than hand-rolling
   tile layouts), export it as `.are` + `.git` + `.gic`, then convert
   to JSON via `nwn_gff` and drop into `unpacked/`. Or copy a small existing
   area trio and edit.
2. The three files must share a base name = the area's ResRef.
3. **Append the new ResRef** to `module.ifo.json` →
   `Mod_Area_list.value` as a `{ "__struct_id": 6, "Area_Name": …}`
   struct. Without this the engine won't load the area.
4. Wire transitions: triggers (`.utt`) with `OnEnter` scripts that call
   `JumpToLocation`/`JumpToObject`, or doors (`.utd`) with a
   `LinkedTo` waypoint tag.
5. Repack — script compile errors will surface here.

### Add or edit a conversation

For small edits to existing dialogues, hand-editing `.dlg.json` is fine
if you understand the index linkage (see Conversation section).

For new conversations or large edits, **use the toolset** — index
bookkeeping is tedious to get right by hand. Round-trip will leave the
dialogue clean.

To wire a creature to its conversation: set
`Conversation.value` on the `.utc.json` (and on any placed instances in
`.git.json`) to the dialogue's resref (filename without `.dlg.json`).

### Add a script

1. Create `unpacked/myscript.nss` with `void main()` (or
   `int StartingConditional()` for a conditional).
2. Reference its resref (no extension) from wherever — a creature's
   `Script*` field, a door's `OnOpen`, a dialogue node's `Script`, etc.
3. Repack — compilation errors will appear with file/line.

### Add or edit a journal quest

Edit `module.jrl.json`:

1. Add a new struct to `Categories.value` with a unique `Tag`, a `Name`,
   and an `EntryList` with stages (`ID=1`, `ID=2`, … `End=1` on final).
2. Reference the quest from scripts via
   `AddJournalQuestEntry("MyQuestTag", 1, oPC);`.

### Edit module-level event hooks

Edit `module.ifo.json`. Set the relevant `Mod_On*` field's `value` to
the resref of an `.nss` script (no extension). The script must compile.
If you're adding the *first* implementation of a hitherto-unused hook,
add the script to `Mod_CacheNSSList` only if it's hot-path.

## Gotchas

- **ResRef collisions are silent.** Two blueprints of the same type with
  the same `TemplateResRef` are an error you'll see at pack time;
  *across* types you can have e.g. an item and a creature both named
  `foo` (they live in different namespaces). Stick to unique resrefs to
  keep your sanity.
- **`.git` and `.gic` are positional.** They share an instance ordering;
  reordering one without the other breaks comments. When deleting an
  instance, delete from both at the same index.
- **Dialogue `Index` fields are positional.** Removing an entry
  re-indexes the list. Easier to leave orphans than to renumber.
- **`Cost` on items is a `dword`.** Don't set it to a negative value.
- **`Conversation` field is a `resref`, not a tag.** Easy to confuse;
  it's the dialogue's filename, lowercase, ≤ 16 chars.
- **CEP HAKs are a hard dependency.** Most appearance IDs above ~600,
  most placeable models, and many item types come from the CEP HAK pack
  listed in `Mod_HakList`. Renaming or removing those breaks the module.
- **The custom TLK is `cep`.** Any `cexolocstring` `id` lookup resolves
  via `cep.tlk`. New IDs would require modifying the TLK; for new
  content, prefer inline strings (`{"0": "..."}`) and skip the TLK
  altogether.
- **Don't commit `dist/` or `*.ncs`.** `.gitignore` covers these but be
  watchful when adding files.
- **Path handling.** `unpack.sh` symlinks the source `.mod` to
  `/tmp/homers_lotr_v3.mod` because `nwn_erf` chokes on apostrophes in
  paths. The module file in NWN's data dir is literally
  `Homer's LOTR VEL v3.mod`.
- **The `.ptm` plot manager file is legacy.** It's a binary blob from
  the old plot wizard; effectively empty in this module. Leave it alone.
- **Scripts can fail silently in-game** — a missing or uncompiled
  `Mod_OnHeartbeat` script just means no heartbeat code runs, with no
  in-game error. Always check for compile errors at repack time and
  test the affected event in a fresh module load.

## Verifying a change

1. `./repack.sh` — compiles all changed scripts and packs the `.mod`.
   Compilation errors here are the first signal something's wrong;
   the script will halt and the message includes file + line.
2. Open the module in the NWN:EE toolset for a quick structural sanity
   check (it'll refuse to open a corrupt `.mod`).
3. Launch NWN:EE and load the module. Use the in-game DM client (this
   module ships dmfi/dmw, so DM tools are available) to teleport to the
   relevant area and exercise the changed feature.
4. Tail the NWN log if something silent is going wrong:
   `~/.local/share/Neverwinter Nights/logs/nwclientLog1.txt` (Linux).

The module has no automated test suite — verification is manual,
in-game.

## Useful references

- NWN Lexicon — script function reference: <https://nwnlexicon.com>
- nwn.wiki — file format docs (GFF, ARE, UTC, etc): <https://nwn.wiki>
- `niv/neverwinter.nim` — the underlying CLI tools, including
  `nwn_gff` JSON conventions: <https://github.com/niv/neverwinter.nim>
- `squattingmonk/nasher` — the build wrapper: <https://github.com/squattingmonk/nasher>
- CEP (Community Expansion Pack) docs — Vault: <https://neverwintervault.org>
