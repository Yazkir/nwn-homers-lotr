# Slotted Items (Gem Socketing) System — Design Notes

> Status: **draft plan**, not yet implemented. To be refined / implemented later.

## Context

The module currently has **no** gem-socketing / "slotted items" mechanic. The goal is a
system where equipment carries a number of **sockets**, and players insert **gems** that
permanently grant item properties. It must:

1. Roll out to **players with pre-existing items** (retroactive socket grants).
2. Use **gem rarity tiers** — common gems from standard/common mobs, rare gems from bosses.
3. Support **retroactive updates** — bump a version stamp and existing items re-reconcile
   to the latest socket schema on next login.
4. **Not send players to jail.** Socketed properties must be recognized as legitimate by
   the existing Forge contraband / "pit prison" illegal-item checks
   (`forge_scan_step.nss` → `ForgeItemLegality` in `forge_inc.nss`).

Rather than import a foreign Neverwinter Vault socket mod (which would clash with CEP, the
local persistence conventions, and the Forge legality system), this builds a **native
socket layer on the existing infrastructure**: the Forge's item-property apply/inspect
helpers, the chunked login-scan retroactive pattern, item-local `.bic` stamps, the
generated-include pattern (`gen-forge-legal.py`), and the bestiary universal OnDeath wrapper.

## Design decisions (confirmed with user)

- **Socket UI:** standalone usable gem — activate the gem, target the equipment.
- **Schema:** per-item socket count from a **generated lookup** (`resref → count` + value/
  base-item tier fallback), compiled to `socket_def_inc.nss` by a `bin/` python script
  (mirrors `bin/gen-forge-legal.py` → `forge_legal_inc.nss`).
- **Retroactive rollout:** a login reconciliation pass brings each player-owned item up to
  its defined socket count (adds missing sockets only, never removes), version-stamped.
- **Gem rarity by CR (drop curve across all creatures):** gems come in **rarity tiers**
  (e.g. common → uncommon → rare → epic). **Common/standard mobs drop common gems**; higher
  CR drops rarer gems; **bosses drop rare/epic gems**. One scripted drop hook on the universal
  creature-death path keys the rarity band off `GetChallengeRating`, with a weighted random
  "upgrade" so the same creature can occasionally roll one band higher.
- **Gem effects:** each gem resref = a **fixed** item property; socketing is **permanent**
  (gem consumed, no extraction).

## Data model (item-local vars — persist in the `.bic`, survive trade)

Stored on each socketable item, mirroring how `FORGE_CLEAN` / `FORGE_CEIL` already ride in
the `.bic` (`forge_inc.nss:40-48`):

| Var | Type | Meaning |
|-----|------|---------|
| `SOCKET_MAX` | int | sockets this item has (set by reconciliation from the schema) |
| `SOCKET_FILLED` | int | how many are filled |
| `SOCKET_n_GEM` (n=0..MAX-1) | string | gem **resref** in slot n (empty = open) |
| `SOCKET_VER` | int | schema version stamp; bump `SOCKET_VER_CUR` to force re-reconcile |

Recording the gem resref per slot is what makes the legality reconstruction (below) possible.

## New files

- **`gem_inc.nss`** — shared include. Constants (`SOCKET_VER_CUR`, rarity bands, drop chances,
  `GEM_*` keys), socket var helpers, `GemBuildProperty(object oGem)` (returns the gem's
  `itemproperty` from its blueprint locals — modeled on `GetNewProperty()` in
  `itemprocs.nss`, but reading locals off the gem object, not the PC),
  `GemReconcileItem(oItem)`, `GemSocketSummary(oItem)` (for description/feedback), gem rarity
  pools, and `GemBeginScan(oPC)` (queues inventory like `ForgeBeginScan` in `forge_inc.nss`).
  Note `forge_inc.nss`'s warning: do **not** `#include "itemprocs"` from inside an include
  consumed alongside it — include both side-by-side in the leaf scripts instead.
- **`socket_def_inc.nss`** — **GENERATED**, do not hand-edit. Exposes
  `int GemSocketMax(string sResref, int nBaseItem, int nValue)` returning the schema socket
  count (explicit resref override, else value/base-item tier fallback).
- **`gem_activate.nss`** — the socket action (invoked from `dmfi_activate`, see below).
- **`gem_scan_step.nss`** — one chunked reconciliation step, a near-clone of
  `forge_scan_step.nss` (own `GEM_SCAN_*` locals so it never collides with `FORGE_SCAN_*`).
- **`gem_drop.nss`** — CR→rarity drop on every creature death (common mobs → common gems,
  bosses → rare/epic), with a weighted random upgrade. Gem pools are keyed by rarity band.
- **Gem `.uti.json` blueprints**, grouped by **rarity band** (common/uncommon/rare/epic) and
  effect — e.g. `gem_common_fire`, `gem_rare_str`, …. Each is a non-equippable gem with a
  **"Cast Spell: Unique Power – Self Only"** item property (so activation fires
  `OnActivateItem`) and blueprint local vars describing its effect (`GEM_PROP`, `GEM_P1/2/3`,
  `GEM_RARITY`) read by `GemBuildProperty`. Stronger properties live on rarer bands. Add a
  palette entry (`itempalcus.itp.json`). The existing `1kgem`/`10kgem`/`100kgem` are
  vendor-trash — **do not reuse them.**
- **`bin/gen-socket-defs.py`** + a **`socket_defs.json`** config (resref overrides + tier
  rules). Scans `unpacked/*.uti.json` for base item / gold value and emits
  `socket_def_inc.nss`. Mirrors `bin/gen-forge-legal.py`. `forge_legal_inc.nss` appears
  committed, so commit `socket_def_inc.nss` too.

## Files to modify

- **`dmfi_activate.nss`** — the live `Mod_OnActvtItem` handler. Add an early branch: if the
  activated item is a gem (tag prefix `gem_` or a `GEM_RARITY` local), `ExecuteScript("gem_activate")`
  and `return`. (It already supports x2 tag-based dispatch at line 45 via
  `GetUserDefinedItemEventScriptName`; an explicit branch is simpler and matches the existing
  `DyeKit`/`bestiarybook` branches.)
- **`hgll_cliententer.nss`** — add `DelayCommand(7.0, GemBeginScan(oPC));` next to the
  existing `DelayCommand(6.0, ForgeBeginScan(oPC));` (line 107). This is the retroactive
  rollout + update trigger: a bumped `SOCKET_VER_CUR` re-reconciles all items at next login.
- **`forge_inc.nss` — `ForgeItemLegality` (CRITICAL, the jail concern).** Before it
  declares an item illegal (fingerprint not whitelisted / over value or prop caps), it must
  account for socketed gems:
  1. Reconstruct the **expected** property set = blueprint/whitelist baseline **plus** the
     properties contributed by each recorded `SOCKET_n_GEM` resref (via `GemBuildProperty`).
     If the item's actual permanent properties equal baseline + socket contributions, it is
     **legal**, even though the raw fingerprint isn't in `forge_legal_inc.nss`.
  2. Raise the effective value / prop-count ceiling by the socket contributions (or stamp
     `FORGE_CEIL` on socket, as `modifyitem.nss` already does for Appraise-extended items),
     so legitimate socketing doesn't trip `FORGE_LEGAL_MAX_PROPS` (6) / `FORGE_LEGAL_MAX_VALUE`
     (750000). Anti-exploit: a gem only applies when it lands in a real schema socket
     (`GemSocketMax > SOCKET_FILLED`) and its property is bounded by gem rarity, so this can't
     be used to launder arbitrary forge value.
  - `gem_activate.nss` must also `DeleteLocalInt(oItem, "FORGE_CLEAN")` after socketing (as
    `modifyitem.nss` does) so the item is re-validated under the new rules next scan.
- **Creature death hook for gem drops.** Add `ExecuteScript("gem_drop", OBJECT_SELF)`
  to the universal creature-death path. Preferred hook: **`bst_ondeath.nss`** (the bestiary
  death handler that `bst_install` already wraps onto every spawned creature) — uniform
  coverage of all current and future creatures without editing 900+ blueprints. Fallback for
  any unwrapped creatures: `nw_c2_default9.nss` (default creature OnDeath, right after
  `CTG_GenerateNPCTreasure`).

## Behavior detail

**Socketing (`gem_activate.nss`):** `oGem = GetItemActivated()`, `oPC = GetItemActivator()`,
`oTarget = GetItemActivatedTarget()`. Validate target is an item the PC owns/equips and is
socketable (`GemReconcileItem` then `SOCKET_MAX > 0`). If `SOCKET_FILLED < SOCKET_MAX`:
`AddItemProperty(DURATION_TYPE_PERMANENT, GemBuildProperty(oGem), oTarget)` (stock add, as
the forge uses — not `IPSafeAddItemProperty`), set `SOCKET_<filled>_GEM = GetResRef(oGem)`,
increment `SOCKET_FILLED`, raise `FORGE_CEIL`, clear `FORGE_CLEAN`, `DestroyObject(oGem)`
(consumed), update description/feedback. Else: "This item has no open sockets."

**Reconciliation (`gem_scan_step.nss`):** per queued item, `nWant = GemSocketMax(resref,
baseitem, value)`; if `SOCKET_VER` stale and `nWant > SOCKET_MAX`, set `SOCKET_MAX = nWant`
(preserve `SOCKET_FILLED`), stamp `SOCKET_VER = SOCKET_VER_CUR`. Never removes sockets or
properties. Reschedules itself via `DelayCommand(0.1, ...)` exactly like `forge_scan_step`.

**Drops by rarity (`gem_drop.nss`):** `cr = GetChallengeRating(OBJECT_SELF)`; map CR to a
**rarity band** (e.g. CR<5 → common, 5–14 → uncommon, 15–29 → rare, 30+ → epic; bands
tunable, can align with the bestiary's `BST_SF_CR = 60.0` "hard creature" threshold for an
epic cutoff). Roll `d100() <= dropChance(band)` (common mobs have a lower per-kill chance,
bosses higher). On success, apply a weighted upgrade roll (e.g. ~80% base band / ~15% +1
band / ~5% +2 band) so the same creature can occasionally yield a rarer gem, pick a random
gem resref from that band's pool, and `CreateItemOnObject(sGem, <corpse>)`. Drop on the
corpse so normal looting/party rules apply (consistent with how blueprint loot drops today).

## Verification

1. **Build:** run `bin/gen-socket-defs.py`; repack via the `repack-homers-lotr` wrapper (not
   bare `nwn-manager repack`); restart the server; confirm `socket_def_inc.nss`, `gem_*.nss`
   compile clean (the repack dialog-integrity/compile gate will surface errors).
2. **Socket:** give yourself a gem + a socketable weapon, activate gem → target weapon →
   property applied, gem consumed, socket filled, message shown. Activate again with no open
   socket → refusal message.
3. **Persistence + retro update:** log out/in → socket vars persist. Bump `SOCKET_VER_CUR`,
   relog → existing item gains newly-defined sockets (none removed).
4. **Jail safety (the key check):** put a socketed item in inventory and trigger the login
   contraband sweep (`ForgeBeginScan`) → player is **not** jailed; an item with a *forged*
   illegal property still is. Verify against the pit-prison flow.
5. **Rarity drops:** kill common mobs → common gems at low rate; kill high-CR bosses →
   rare/epic gems; confirm occasional one-band-up upgrades.
6. **Wiki:** run `bin/refresh-homers-lotr-wiki` so gem items/sources appear in `item_index.json`.

## Critical files referenced

- `unpacked/forge_inc.nss` — `ForgeItemLegality`, `ForgeBeginScan`, caps, `FORGE_CLEAN`/`FORGE_CEIL` (extend here)
- `unpacked/forge_scan_step.nss` — template for `gem_scan_step.nss`
- `unpacked/forge_legal_inc.nss` + `bin/gen-forge-legal.py` — generated-whitelist pattern to mirror
- `unpacked/itemprocs.nss` (`GetNewProperty`, `CustomAddProperty`) — property-builder template
- `unpacked/modifyitem.nss` — `FORGE_CLEAN` clear + `FORGE_CEIL` stamp precedent
- `unpacked/dmfi_activate.nss` — `Mod_OnActvtItem` handler (add gem branch)
- `unpacked/hgll_cliententer.nss` (~line 107) — login scan wiring (add `GemBeginScan`)
- `unpacked/bst_ondeath.nss` / `bst_install.nss` / `nw_c2_default9.nss` — creature-death hook for drops
- `unpacked/module.ifo.json` — event-handler resref map (no edit needed; handlers already route)
