# Fix: Well of Souls / Azagoth quest + Hanee "Ruin of Annuminas" bridge

## Context

The **Well of Souls** quest is fully built but **unstartable**. Everything except
the quest giver exists:

- Dialogue `unpacked/gondorscribe.dlg.json` (accept → journal entry 1 + gives
  `annuminaskey` via `at_007`; turn-in → 4,000 XP + destroys `azagothshead` via
  `at_008`, journal entry 2 via `at_013`; condition scripts `sc_003` "has head",
  `sc_007` "azagothdead").
- Journal category **The Well of Souls** (entries 1 & 2) in `module.jrl.json`.
- The boss **Azagoth** spawns from an encounter in `unpacked/ruinsofannuminas.git.json`
  (CR 37, tag/resref `azagoth`) and carries `azagothshead` in inventory.

**The gap:** no creature in the module carries the `gondorscribe` conversation
(`grep gondorscribe unpacked/` matches only the .dlg file), and
`ruinsofannuminas.git.json` has **zero static creatures** (`Creature List` count 0).
The Gondor Scribe NPC was designed but never created or placed, so the player can
never accept or turn in the quest. A prior 2026-05-28 pass only fixed the DLG Quest
field name (`wellofsouls` → `The Well of Souls`); it did not notice the missing NPC.

Separately, **Hanee the Loon** (Bree, `b_oldwoman_con1.dlg.json`) gives the
**Ruin of Annuminas** quest (journal entry 1 only) — a lore breadcrumb pointing
north to Annuminas with no completion.

## Intended flow (per user)

Two-stage arc tying the two quests together. Ruins of Annuminas is close to Bree,
so Hanee keeps sending players there as originally.

1. **Hanee** (Bree) → "Ruin of Annuminas" entry 1: go north to the ruins
   (unchanged direction).
2. Player travels to **Ruins of Annuminas**, kills **Azagoth** (existing area
   encounter), loots **Azagoth's Head**.
3. Player brings the head **back to Hanee** → she gives an **intermediate 5,000 XP**
   and, in her loony way, suggests the "fancy wizard folks over in Gondor" (the
   High Wizard's tower) would be interested. She does **not** take the head.
   "Ruin of Annuminas" advances to entry 2 (completed/handoff).
4. Player takes the head to the **Gondor Scribe** in **Tower of the High Wizard:
   Ground Floor** (`area011`, area Tag `Area001`) — a safe friendly area already
   populated with Gondorian Wizards + a guard (all `FactionID` 6 = "Good"). She
   reacts to the head (existing `sc_003` "has head" branch → entry 10), awards
   **10,000 XP** (raised from 4,000), consumes the head, gives the **Annuminas Key**,
   and completes **The Well of Souls** (entry 2).
5. **Alternate start:** a player who reaches the scribe **without** the head still
   gets the quest from her (existing greeting → accept branch sets Well of Souls
   entry 1 + gives the key), then kills Azagoth and returns. The scribe dialogue
   already supports both paths via its `StartingList` conditions.

The manual `docs.manual/QuestGuide.html` wrongly marks Well of Souls "Working" and
tells players to find Azagoth in the "Moria Byss / Balrog of Moria area" — Azagoth
actually spawns in **Ruins of Annuminas**; the Balrog is the separate creature
`azagoth001` (tag `TheBalrogofMoria`).

Intended outcome: place the Gondor Scribe so Well of Souls is fully playable,
turn Hanee's breadcrumb into a real two-stage arc with an intermediate reward and a
loony handoff to the scribe, rebalance the rewards, and correct the docs.

## Changes

### 1. Create the Gondor Scribe blueprint — `unpacked/gondorscribe.utc.json` (new)

Copy an existing in-repo female commoner blueprint as the base:
`unpacked/comfemale002.utc.json` (appearance 250, `FactionID` 2 / Commoner).
Then set:
- `TemplateResRef` → `gondorscribe`, `Tag` → `GondorScribe`
- `FirstName` → `Gondor`, `LastName` → `Scribe` (so name shows "Gondor Scribe")
- `Conversation` → `gondorscribe`
- `FactionID` → 6 ("Good"), matching the tower's existing Gondorians.

Add it to the creature palette `creaturepalcus.itp.json` only if other custom NPCs
are listed there (optional — not required for runtime).

### 2. Place the scribe in Tower of the High Wizard: Ground Floor — `unpacked/area011.git.json` + `.gic.json`

Add one creature instance to `Creature List` near the two Gondorian Wizards
(currently at ~X 32–37, Y 11; guard at X 35, Y 39 — the room spans that area).
Place the scribe near the wizards, e.g. around **X≈40, Y≈11**, facing into the
room. **Run `bin/place-helper.py` for `area011` first** (per project memory) to
pick reachable, clearance-checked coordinates + bearing.

Instance shape (per project memory on git/gic):
- Creature struct uses `__struct_id` 4; position fields `XPosition`/`YPosition`/
  `XOrientation`/`YOrientation` (not the placeable X/Y/Z/Bearing form).
- Minimum override fields: `TemplateResRef`=`gondorscribe`, plus the position/
  orientation; let the rest resolve from the blueprint.
- Add a matching `Creature List` entry to `area011.gic.json` with hardcoded
  `__struct_id` 4 (NOT a loop index — that crashes the toolset).

### 3. Hanee head turn-in — intermediate 5,000 XP + loony handoff

Hanee's directions to the ruins stay **unchanged** (entry 1). Add a head-reaction
branch that fires when the player returns carrying `azagothshead`.

- **`b_oldwoman_con1.dlg.json`**: add a new conditional entry to the top of
  `StartingList` (evaluated before the plain greeting at index 0) gated by a new
  `StartingConditional`. The new NPC entry node carries loony verbiage, e.g.:
  *"Ooh! Ooh — is that a HEAD ya got there? Heehee, gruesome lovely! Y'know, them
  fancy robe-wearin' wizard folk over in Gondor — up the High Wizard's tower — they'd
  give their pointy hats for a gawp at that. Off ya trot, dearie!"* Attach the reward
  action script to this node.
- New `unpacked/sc_hanee_head.nss` (StartingConditional, reuse `nw_i0_tool`):
  `return CheckPlayerForItem(GetPCSpeaker(),"azagothshead") && !GetLocalInt(GetPCSpeaker(),"hanee_head_reward");`
  (the flag stops the 5k from being re-farmed since Hanee does **not** take the head).
- New `unpacked/at_hanee_head.nss` (action, reuse `nw_i0_tool` for `RewardPartyXP`):
  `RewardPartyXP(5000, GetPCSpeaker()); SetLocalInt(GetPCSpeaker(),"hanee_head_reward",1); AddJournalQuestEntry("Ruin of Annuminas", 2, GetPCSpeaker());`
  — keeps the head on the player for the scribe turn-in.
- `module.jrl.json`: add **entry 2** to the **Ruin of Annuminas** category, e.g.
  *"I slew Azagoth and brought his head to old Hanee in Bree. She raved that the
  wizards at the Tower of the High Wizard in Gondor would want to see it."* Set its
  `End` flag to 1.

### 4. Rebalance the scribe turn-in reward — `unpacked/at_008.nss`

Change `RewardPartyXP(4000, ...)` → `RewardPartyXP(10000, ...)`. This script already
consumes `azagothshead` and is the scribe's "you brought the head" turn-in
(`gondorscribe.dlg.json` entry 10, gated by `sc_003`). No other wiring needed — the
scribe's existing `StartingList` handles both "arrive with head" (turn-in) and
"start cold without head" (greeting → accept sets Well of Souls entry 1 + key).

### 5. Fix the manual — `docs.manual/QuestGuide.html`

- Well of Souls card: keep the "Working" badge (true after this fix) but replace
  the stale note — the Gondor Scribe is now placed in the **Tower of the High
  Wizard: Ground Floor** (previously the conversation existed with no NPC). Update
  the reward to **10,000 XP** + Annuminas Key.
- Correct the "How to play" step: Azagoth is fought in **Ruins of Annuminas**, not
  "Moria Byss / Balrog of Moria area." Fix the giver line "Gondor Scribe, Gondor
  area" → "Gondor Scribe, Tower of the High Wizard: Ground Floor."
- Ruin of Annuminas card: describe the two-stage arc — Hanee sends you to the ruins,
  returning Azagoth's head to her gives **5,000 XP** and points you to the Gondor
  scribe, who pays **10,000 XP** for the head.
- (`docs/` regenerates from `docs.manual/` via `bin/refresh-homers-lotr-wiki`; do
  not hand-edit `docs/`.)

### Deferred decision — Annuminas Key (UNDECIDED)

The **Annuminas Key** (tag `AnnuminasKey`) unlocks four locked `Chest1` placeables
in **Ruins of Annuminas** (`Locked=1`, `KeyName="AnnuminasKey"`, `KeyRequired=0` so
also pickable). The key is only granted on the scribe's *cold-start accept* node
(`at_007`), so on the new Hanee-first path the player reaches/loots those chests
before ever getting the key — making it vestigial on the main path. **Options not
yet chosen:** (a) leave as-is; (b) set `KeyRequired=1` on the 4 chests (risky —
gates loot behind the cold-start path); (c) also grant the key at the Hanee handoff
(`at_hanee_head`). Revisit before implementing. Separately, the wiki generator
(in `nwn_manager`) does not render key↔lock relationships — noted as future work,
the module data is correct.

### 6. (Optional) `quests-uat.txt`

Update the Tier 1 "Well of Souls" / "Ruin of Annuminas" notes and Tier 4 reward row
(now 10,000 XP at the scribe, 5,000 at Hanee) — it is a working artifact, safe to
trim.

## Verification

1. `nwn-manager repack` — must compile `sc_hanee_head.nss` / `at_hanee_head.nss`
   with **no script errors** and pack the new `.utc`/`.git`/`.gic`/`.jrl` cleanly.
2. Load the `.mod` in NWN:EE (DM client helps — `dm_jumptopoint`). **Main path:**
   - Bree: talk to **Hanee the Loon**, accept → journal **Ruin of Annuminas** entry 1
     (directions to the ruins, unchanged).
   - Travel to **Ruins of Annuminas**, kill **Azagoth** (area encounter), loot
     **Azagoth's Head**.
   - Return to **Hanee** with the head → loony branch fires: **+5,000 XP**, head
     **kept**, journal entry 2 (points to the Gondor wizards). Talk again → 5k does
     **not** repeat (flag set).
   - Go to **Tower of the High Wizard: Ground Floor** — the **Gondor Scribe** is
     present near the wizards, friendly. With the head, her turn-in node fires:
     **+10,000 XP**, head consumed, **Annuminas Key** received, **The Well of Souls**
     shows completed (entry 2).
   - **Cold-start path:** reach the scribe **without** the head → greeting → accept
     ("Alright, where is this portal?") sets **The Well of Souls** entry 1 + gives the
     key; then kill Azagoth and return for the 10k turn-in.
   - Decline branch and the plain greeting still exit cleanly.
3. After edits, run `bin/refresh-homers-lotr-wiki` to rebuild `docs/` and confirm
   the Quests pages show the corrected Well of Souls / Ruin of Annuminas info and
   the scribe now appears as a placed creature.

## Key files

- `unpacked/gondorscribe.utc.json` (new), base `unpacked/comfemale002.utc.json`
- `unpacked/area011.git.json`, `unpacked/area011.gic.json` (scribe placement)
- `unpacked/b_oldwoman_con1.dlg.json` (Hanee head-turn-in branch)
- `unpacked/sc_hanee_head.nss`, `unpacked/at_hanee_head.nss` (new — 5k reward gate/action)
- `unpacked/at_008.nss` (scribe reward 4,000 → 10,000)
- `unpacked/module.jrl.json` (Ruin of Annuminas entry 2)
- `docs.manual/QuestGuide.html`
- `bin/place-helper.py` (coordinate picking), `bin/refresh-homers-lotr-wiki` (rebuild)
