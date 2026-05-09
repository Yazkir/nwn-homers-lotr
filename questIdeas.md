# Neverwinter Nights 1 — Middle-earth Quest Compendium

> **Implementation context.** This compendium was originally drafted as
> generic concept text. Below, every quest has been annotated for
> compatibility with the actual Homer's LOTR VEL v3 module
> (`unpacked/`). See **Module compatibility audit** at the end for the
> shared infrastructure work that affects most of these quests.
>
> **Authoring conventions assumed throughout** (consistent with
> `CLAUDE.md`):
> - Journal entries are added to `module.jrl.json` (`Categories.value`)
>   with a unique `Tag`. New stage entries get a unique `ID`; final
>   stage carries `End=1`. Trigger from script with
>   `AddJournalQuestEntry("MyTag", <stageID>, oPC);`.
> - Quest progress is tracked with `GetLocalInt(oPC, "<questvar>")` for
>   in-session state and `GetCampaignInt("homerlotr", "<key>", oPC)` /
>   `SetCampaignInt(...)` for persistence (cooldowns, completion,
>   server-state variables). The module uses NO NWNX and NO SQL — only
>   the campaign DB.
> - Conditional dialogues use `int StartingConditional()` (see
>   `sc_044.nss`); action dialogues use `void main()` (see `at_014.nss`).
>   Match the existing naming pattern (`sc_NNN`, `at_NNN`) or use a
>   descriptive name.
> - Daily/weekly cooldowns: `GetCampaignInt(... , "lastdone_<questtag>",
>   oPC)` storing a Unix-style timestamp computed from `GetCalendarYear()
>   * 12 * 28 + GetCalendarMonth() * 28 + GetCalendarDay()` (in-game
>   day-stamp), or `GetTimeSecond()` etc. for real-time cooldowns.

---

## ⚔️ FACTION QUESTS: GOOD vs EVIL

*Players align with a faction early on. Many quests are mirrored — same conflict, opposite objectives.*

> **Compatibility note — factions.** `repute.fac.json` ships with only
> the engine-required factions (PC, Hostile, Commoner, Merchant,
> Defender) plus three globals: **Evil**, **Good**, **Neutral**. There
> is **no** Gondor / Rohan / Rivendell / Lothlórien / Mordor /
> Isengard / Goblin-town / Haradrim faction yet. The "rep token"
> rewards below collapse to **Good** or **Evil** standing unless we
> first add per-realm factions and a `RepList` rep matrix. Recommend a
> one-time `repute.fac.json` expansion (10–15 new factions, alignment
> blocks of pairwise reps) before any faction-rep reward is meaningful.
> Until then, "Good rep" / "Evil rep" should be implemented as
> `AdjustReputation(oPC, GetObjectByTag("FactionAnchor_<name>"),
> +/-N)` against a single anchor NPC per faction.

---

### GOOD FACTIONS
*(Free Peoples: Gondor, Rohan, Rivendell, Lothlórien, Erebor, the Shire)*

**[Daily] The Palantír Watch** *(Lvl 20+)*
Agents of Sauron are attempting to corrupt or locate one of the remaining seeing-stones. Good players must escort a blindfolded lore-keeper to the stone's vault and reinforce its warding seals before the enemy agents arrive. Reward: *Seal of the Faithful* (stacking faction reputation token), XP.
> **Implementation:** Use `toweroforthanc.are.json` (Orthanc
> palantír) or stage at Minas Tirith (`minastirith.are.json`) for the
> Anor stone. The "lore-keeper" can be a new commoner UTC with low HP
> who follows via `ActionForceFollowObject(oPC, 2.0f)`; clone the
> behaviour from any existing escort creature. Spawn 2–3 waves of
> "Mordor agent" Hostile-faction Uruks via `CreateObject` on a
> heartbeat trigger inside the area. Stacking token = `uti` with
> `Stacking=TRUE` and `Cost=0`; persistence handled by inventory count.

**[Weekly] Riders of the Mark** *(Lvl 30+)*
A Rohirric patrol has gone silent near Helm's Deep. Investigate, rescue survivors, and hold the gate against a Dunlending/Uruk-hai raid until reinforcements arrive. Reward: *Éored Battle-Harness* (+8 AC armor), Rohan rep.
> **Implementation:** All required areas exist —
> `helmsdeep001.are.json`, `pathtohelmsdeep.are.json`,
> `dunland.are.json`, `dunlandwarparty.are.json`. Rohirrim NPCs already
> present (`riddermarkswords.utc.json`,
> `riddermarkguardi.utc.json`). Wave defence: scripted `OnEnter`
> trigger spawns waves on a 60s `DelayCommand` chain; "reinforcements
> arrive" = spawning friendly `riddermark*` plus
> `ApplyEffectAtLocation(EFFECT_VISUALEFFECT_VFX_FNF_HORN_OF_VALHALLA, ...)`
> for flavour. **Note:** +8 AC armor exceeds NWN's natural item-property
> ceilings (AC bonus caps at +5 for the armor enhancement property);
> rebalance to AC +5 plus situational bonuses (e.g. AC vs Goblinoid +3),
> or rely on CEP's high-power property tables.

**[Weekly] The White Council's Errand** *(Lvl 40+)*
Gandalf dispatches the player to retrieve a fragment of a pre-Númenórean map from the ruins of Ost-in-Edhil (Eregion). Saruman's agents are already there. Branching: if you share the map with Saruman's emissary (deception check), you gain short-term Isengard rep but lose White Council standing permanently.
> **Implementation:** Eregion/Ost-in-Edhil is **not in the module** —
> nearest substitutes are `ruinsofannuminas.are.json` or
> `tharbadbridge.are.json`/`tharbadwest001.are.json`. Either rebrand or
> author a new area (see CLAUDE.md → "Add a new area"). Gandalf NPC
> exists (`gandalf001.utc.json`, tag `Gandalf`). Saruman exists
> (`sarumanthewhi001.utc.json`, conv `saurman`). Branching: persist the
> betrayal as `SetCampaignInt("homerlotr", "whitecouncil_status",
> -1, oPC)` so Gandalf's dialogues thereafter (via a
> `StartingConditional`) refuse to deal with the PC.

**[One-Off] The Dead Marshes Lantern** *(Lvl 35)*
A hobbit courier carrying a diplomatic letter has wandered into the Dead Marshes and become entranced by the wight-lights. Rescue them without yourself becoming entranced (Will saves every 30 seconds). Reward: *Elven Waystone* (free teleport token x3).
> **Implementation:** `deadmarshes.are.json` and
> `deadmarshcrypts.are.json` already exist. "Will save every 30s"
> implemented as area `OnHeartbeat` script — heartbeat fires every 6s
> in NWN, so check `GetCalendarSecond() % 30 == 0` or use a
> per-PC counter local. On failed save, apply
> `EFFECT_TYPE_CONFUSED` for 6s. Lantern UTI = a unique
> `BaseItem=Torch` with on-hit ability (or just plot-flagged). The
> *Elven Waystone* item should script
> `JumpToLocation(GetLocation(GetWaypointByTag("WP_Rivendell_Hub")))`
> with charges decremented; clone an existing teleport scroll if the
> module has one.

**[One-Off] Eagles of the Eyrie** *(Lvl 50+)*
Gwaihir asks for help clearing a nest of Nazgûl-corrupted wargs from the approaches to the Eyrie — the Eagles won't fly while their approach is threatened. Completing this unlocks the **Eagle Courier** fast-travel network for good-aligned players.
> **Implementation:** No Eyrie area in the module; nearest is
> `mistymountainsa.are.json` / `mistymountainsb.are.json` — author or
> reskin one peak as the Eagles' aerie. Gwaihir = new UTC using
> appearance row for *Giant Eagle* (CEP `c_eaglegt` or appearance type
> 116/137 in stock 2da). Eagle Courier network = a placeable
> ("nest") in each Free-Peoples capital that opens a conversation with
> destination options; gate on
> `GetCampaignInt("homerlotr","eagle_courier_unlocked",oPC) == 1`.

---

### EVIL FACTIONS
*(Servants of Sauron, Saruman's Uruk-hai, Nazgûl Court, Goblin-town, Haradrim Raiders)*

**[Daily] Sowing Discord in Bree** *(Lvl 15+)*
Infiltrate the Prancing Pony, plant forged letters implicating Ranger spies among the locals, and leave before the Sheriff investigates. Stealth/Bluff checks. Reward: Morgul silver (evil currency), *Ranger-Bane Cloak*.
> **Implementation:** Bree well-supported (`bree.are.json`,
> `theprancingpo001.are.json`, `theprancingpo002.are.json`,
> `ponyinn3.are.json`, `billfernyshouse.are.json`). "Plant letter" =
> `CreateItemOnObject` into a placeable's inventory or
> `SetUseableFlag` on a placeable's inventory; sheriff arrival = a
> heartbeat-counted spawn after N rounds. Morgul silver = a custom
> stacking UTI (clone a gold-piece-style item; cannot replace gold —
> NWN has only one gold currency, so this is a parallel token).

**[Weekly] The Sacking of Pelargir** *(Lvl 35+)*
Lead a Corsair raid on the Gondorian harbor-city. Burn three supply warehouses, sink two warships, and capture the harbormaster for interrogation — but a Good-faction player group may be defending simultaneously (PvP-enabled zone). Reward: *Corsair Admiral's Cutlass* (+10, keen), massive Evil rep.
> **Implementation:** **Pelargir does not exist in the module** —
> nearest analogues are `hiddenport.are.json` or coastal Gondor
> (`gondorwesta.are.json`, `gondorwestb.are.json`). Either author a new
> port area or rebrand. PvP zones cannot be toggled at runtime in NWN
> the way the text implies — the module has a single
> `Mod_PVPSetting` (party/none/full) in `module.ifo.json`. Workaround:
> mark Hostile-faction NPCs that any player can attack and add
> `SetIsTemporaryEnemy()` between opposing-faction PCs on entry. **+10
> keen weapon:** weapon enhancement +10 is engine-legal but very high;
> consider `Cost` and `Damage Bonus 2d6` rather than a flat `+10`
> enhancement to stay below the +20 BAB AC race.

**[Weekly] Unmaking the Wards** *(Lvl 40+)*
Sauron's Eye has detected ancient Elvish wards in Lothlórien's outer forest weakening. Sneak in (heavy magic detection traps), destroy three ward-stones, and extract before Haldir's patrols execute you on sight. Reward: *Shadow-Thread Armor* (+9 AC, Hide bonus), Mordor rep.
> **Implementation:** `lothlorien.are.json`, `lothloriennorth.are.json`,
> `lorienforrestout.are.json`, `lorienhightreele.are.json`,
> `lothlorienflets.are.json` all exist. Ward-stones = three
> placeables (UTP) with `OnUsed` script that decrements an area-local
> counter; on count==3, fire journal advance and apply +Hide buff.
> Detection traps: NWN `TRAP_BASE_TYPE_*` palette already includes
> magical detect-types. Haldir patrol: no Haldir UTC — clone an Elvish
> guard and tag it `Haldir`.

**[One-Off] The Nine Are Abroad** *(Lvl 45)*
A Nazgûl's black horse has been slain and the wraith is momentarily weakened. Sauron orders you to recover the horse's enchanted iron shoes — components for a ritual — from the Good players who looted them before the next sunrise. Time-limited. Reward: *Morgul-Blade Fragment* (unique crafting component).
> **Implementation:** Witch King NPC exists (`witchking.utc.json`,
> tag `WitchKing`); Nazgûl guildhouse area exists
> (`nazgulguildhouse.are.json`). "Sunrise" timer: track via
> `GetTimeHour()` rolling past `Mod_DawnHour` (currently 6); fail
> the quest if not done. The "Good players looted them" mechanic is
> intra-PvP and unreliable on a small server — fallback variant: the
> shoes are held by a lesser Maia patrol of 3 Hostile NPCs in a
> randomized area, picked on quest start.

**[One-Off] Saruman's Voice** *(Lvl 25)*
Pose as a Gondorian merchant and use a scripted persuasion tree (Bluff/Persuade checks) to convince the Steward's aide to divert a shipment of mithril ingots to Isengard instead of Erebor. Pure social quest — no combat. Failure results in guards combat instead. Reward: Isengard rep, *Ring of Silver Tongue* (+5 Persuade/Bluff).
> **Implementation:** Pure-dialogue quest — perfect fit. Use
> `minastirithtemp.are.json` or `minastirith.are.json` for the
> Steward's hall. Bluff/Persuade gating: in dialogue conditional,
> `GetSkillRank(SKILL_BLUFF, oPC) + d20 >= DC` (replicates a skill
> check; standard NWN dialogue idiom). Failure branch =
> `SetIsTemporaryEnemy()` and `ActionAttack(oPC)` on the four nearest
> guards. *Ring of Silver Tongue* = UTI base 52 (ring) with
> `Skill Bonus: Bluff +5` and `Skill Bonus: Persuade +5` properties.

---

---

## 🎓 CLASS QUESTLINES — Level 1 to 60
*Each questline has roughly 8–10 quest nodes spread across the level range, culminating in a unique Tier-6 class-specific reward item (+14 or +15 equivalent).*

> **Compatibility note — class capstones at +14/+15.** The module's
> levelling spec uses **HGLL (Homer's Game Legendary Levels)** for
> levels 41–60 (`hgll_*` scripts; see CLAUDE.md). NWN base item
> properties cap at attack/damage **+20** but the engine convention is
> +5 max for "weapon enhancement bonus" and additional damage typed
> properties stack on top. A "+15 weapon" should therefore be encoded
> as enhancement +5 plus typed damage bonuses (e.g., +2d6 vs Evil,
> +1d6 fire), not as a literal +15 enhancement. Same for "+14/+14
> dual" — implement as +5 enh + 4d6 sneak-attack-style typed bonuses.
>
> Class restriction on the reward item: NWN UTI properties include
> **Use Limitation: Class** (e.g. row 0 = Barbarian) — apply the
> matching row so only the correct class can equip.
>
> Spell-DC modifiers (`Sceptre of Annúminas`, "+3 spell DC all
> schools") are **not a stock item property**. Implement as an OnEquip
> script that calls a custom DC override (none in stock NWN; would
> require either a 2da hak addition or per-spell scripted variants).
> Recommend swapping to "+1 spell penetration" (which is stock) or
> dropping to school-specific DC bumps via custom hak.

---

### 🗡️ FIGHTER — *The Unbroken Shield*
**Theme:** A warrior's journey from conscript to legend, mirroring the lineage of Gondor's soldiers.

| Level | Quest | Summary |
|---|---|---|
| 1 | *First Blood at Bree* | Defend the Prancing Pony from a Brigand raid; learn the combat system's basics |
| 8 | *The Pelennor Drills* | Train under a Gondorian captain; pass three timed combat trials |
| 15 | *Iron Hills Mercenary* | Escort a Dwarf arms caravan through orc ambushes; choose to keep payment or donate to Erebor |
| 22 | *The Last of the Dúnedain* | Assist a dying Ranger captain in pushing back a warg assault; inherit his broken sword |
| 30 | *Reforging at Rivendell* | Bring the broken sword to Elvish smiths; requires gathering three rare ores from dangerous zones |
| 38 | *Siege of Osgiliath* | Hold a crumbling bridge against a Morgul assault for 10 minutes (wave defense) |
| 46 | *The Black Gate Challenge* | Deliver Aragorn's challenge at the Black Gate as his champion; survive three elite Uruk lieutenants |
| 55 | *Armies of the Dead* | Lead the Dead Men of Dunharrow through the Paths of the Dead to relieve a besieged port |
| 60 | *Shield of the West* | Final duel against the Mouth of Sauron in single combat before the Gate |
| **REWARD** | *Aeglos Reborn* | +15 spear, Keen, +8 STR, on-hit Slow (DC 22), unique appearance: glows white in darkness |

> **Implementation:**
> - All required areas exist: `theprancingpo001`, `bree`,
>   `thepelennorfield`, `gondoremynarnen`, `rivendell`,
>   `thesmithyofriven`, `osgilbridge`, `blackgatge`,
>   `dunharrow`, `forgottenking`. Aragorn UTC =
>   `aragornsonofarat.utc.json`.
> - "Broken sword inherit → reforge": create two UTIs (`narsil_broken`,
>   `narsil_reforged`); the dying captain's `OnDeath` does
>   `CreateItemOnObject("narsil_broken", oPC)`. Smiths' dialogue
>   checks `GetItemPossessedBy(oPC, "ore_mithril")` etc., consumes
>   them, replaces broken with reforged.
> - Wave defense (Osgiliath): 10 minutes ≈ 100 heartbeats; spawn 4
>   waves of escalating Hostile-faction Uruks on a `DelayCommand`
>   chain; success = no friendly NPC corpse count ≥ 3.
> - +15 spear / +8 STR: encode as Spear (BaseItem=2 in baseitems.2da)
>   with Enhancement +5, Damage Bonus 2d6 vs Evil, Ability Bonus
>   STR +5 (item ceiling), On-Hit Slow (DC fixed by table —
>   pick CostTable row that gives DC ~22). "+8 STR" alone exceeds
>   stock max — split between item +5 and a permanent stat tome
>   reward. "Glows white in darkness" = `Light: 20m, white` property
>   (CostTable row in `iprp_lightcost.2da`).

---

### 🧙 WIZARD — *The Colour of Power*
**Theme:** An apprentice mage uncovering Istari secrets, eventually choosing a "colour" allegiance.

| Level | Quest | Summary |
|---|---|---|
| 1 | *Cantrips in the Shire* | Help Old Took's birthday party — minor illusions and light spells; comedic tone |
| 8 | *The Ents Remember* | Decode an ancient Quenya inscription in Fangorn for Treebeard |
| 15 | *Tower of Orthanc — Archives* | Infiltrate Isengard's lower library while Saruman sleeps; read three forbidden tomes |
| 22 | *Mirkwood Corruption* | Trace magical blight back to a Necromancer-lieutenant; destroy the corrupting phylactery |
| 30 | *A Wizard's Trial* | Gandalf sets three paradox-puzzles that require creative spell use to solve |
| 38 | *Dol Guldur Assault* | Storm the dark fortress with a small party; reach the inner sanctum |
| 46 | *Choosing the Colour* | **Branching:** Side with Gandalf (White — healing/light spells boost), Saruman (Grey→Many Colours — enchantment boost), or strike out alone (Radagast path — nature/summon boost). Permanent passive unlocked. |
| 55 | *Unraveling Sauron's Weave* | Disrupt the magical resonance binding the Nazgûl to their rings using counter-ritual spells |
| 60 | *The Word That Breaks Walls* | Learn and speak one of the seven Words of Making; destroy the Morannon gate |
| **REWARD** | *Staff of the Ordered Mind* | +15 quarterstaff, +8 INT, spells cast at +2 caster level, 3×/day *Maximized Fireball* (or variant based on colour chosen) |

> **Implementation:**
> - All required areas exist: `shirehobbiton001`, `bagend001`,
>   `fangornforest`, `fangornoutskirts`,
>   `toweroforthanc`, `towerofothancsar`, `isengardinnerrim`,
>   `isengardmagicroo`, `mirkwoodcentral*`, `dolguldur*`,
>   `cavesofdolguldur`, `blackgatge`. Treebeard
>   (`treebeard.utc.json`, tag `TreeBeard`), Gandalf
>   (`gandalf001.utc.json`), Saruman (`sarumanthewhi001.utc.json`),
>   Radagast (`radagastthebrown.utc.json`) all present.
> - "Read three forbidden tomes": placeables with `OnUsed` setting
>   `SetLocalInt(oPC, "wiz_tome_<n>", 1)`; gate the next dialogue with
>   conditional checking all three.
> - "Choosing the Colour" persistent state:
>   `SetCampaignInt("homerlotr", "wizard_colour", n, oPC)` where 1=White,
>   2=Many-Colours, 3=Brown. Gate the capstone item appearance/properties
>   on this value at handout.
> - "+2 caster level": stock NWN supports
>   "Bonus Spell Slot of Level X" but **no flat caster level bonus**.
>   Rewrite as 3×/day Maximize-tag use of Fireball (cast as if caster
>   level +2 within an OnHit/OnActivate script).

---

### 🗝️ ROGUE — *The Long Shadow*
**Theme:** A thief/spy threading through the politics of both sides, always for personal gain.

| Level | Quest | Summary |
|---|---|---|
| 1 | *Picking Pockets in the Prancing Pony* | Lift a Black Rider's message pouch without being detected |
| 8 | *The Smuggler's Road* | Move contraband through a Gondorian checkpoint using disguise and timing |
| 15 | *Gollum's Trail* | Track Gollum through cave systems using footprint clues; optional: capture or follow |
| 22 | *Spidersilk Heist* | Steal a bolt of Shelob's silk from a Mordor alchemist's vault in Minas Morgul's markets |
| 30 | *The Mouth Speaks Lies* | Impersonate a Gondorian envoy at Sauron's parley; extract intelligence without blowing cover |
| 38 | *Stealing the Palantír of Orthanc* | Full stealth mission inside Orthanc; every guard patrol is lethal, no combat permitted |
| 46 | *The Watcher's Blind Spot* | Map Sauron's Eye patrol patterns in Mordor to open a window for a Resistance operation |
| 55 | *Gollum's Bargain* | Gollum offers to show you a way into Barad-dûr's treasury in exchange for protection — trust him or betray him (affects ending) |
| 60 | *The Final Cut* | Rob Sauron's own vault during the chaos of the War's climax |
| **REWARD** | *Shadowmere Blades* | Dual +14/+14 short swords, +8 DEX, Sneak Attack +3d6 bonus, 1×/day *Improved Invisibility* (10 min) |

> **Implementation:**
> - All key areas present: `theprancingpo001`, `breecave`,
>   `breecaverns`, `shelobslair`, `cirithungol`, `thecirithungolpa`,
>   `toweroforthanc`, `mordor*` proxy via `mountdoom*`,
>   `baraddur`, `baraddurkeep`, `baraddurbarracks`. Gollum
>   (`gollum.utc.json`) and Shelob (`shelob001.utc.json`) blueprints
>   exist.
> - "No combat permitted" enforcement: on combat-init,
>   `SignalEvent(area, EventUserDefined(99))` and abort the quest;
>   simpler to use a Stealth check on each guard's view-cone trigger
>   (`OnPerception`).
> - "Sneak Attack +3d6": use UTI property
>   "Massive Critical: 3d6" or stock "Damage Bonus: Piercing 3d6" — NWN
>   has no "sneak attack +Nd6" property. Acceptable substitute for
>   flavour.
> - "1×/day Improved Invisibility (10 min)": stock activate-property
>   table caps spell durations; pick the closest activate-spell row in
>   `iprp_spells.2da`.

---

### 🌿 DRUID — *The Breathing of the World*
**Theme:** Awakening the land itself against Sauron's industrialization and Saruman's deforestation.

| Level | Quest | Summary |
|---|---|---|
| 1 | *The Old Forest Wakes* | Calm an angry Old Man Willow and speak with Tom Bombadil |
| 8 | *Roots and Poison* | Purge Saruman's chemical runoff from a tributary of the Entwash |
| 15 | *Voice of Treebeard* | Serve as translator/intermediary when Treebeard meets an emissary; nature/lore checks |
| 22 | *The Brown Wizard's Garden* | Aid Radagast in healing corrupted animals near Dol Guldur's outskirts |
| 30 | *Entmoot Observer* | Survive three nights alone in Fangorn while the Ents deliberate; fend off Orc scouts without fire |
| 38 | *Huorns to War* | Personally guide a column of Huorns to Helm's Deep, keeping them from turning on allies |
| 46 | *Ungrown Gondor* | Replant the White Tree seedling lineage before Denethor's forces root it out |
| 55 | *Scouring the Shire* | Return home to find the Shire industrialized by Saruman's Men; lead a nature-magic restoration |
| 60 | *The Last Green Word* | Speak the oldest Ent-word — a syllable of creation — into the cracks of Mount Doom |
| **REWARD** | *Heartwood Staff* | +15 staff, +8 WIS, Animal Companion gains +8 all stats, 3×/day *Creeping Doom*, terrain-specific passive regeneration |

> **Implementation:**
> - Areas exist: `oldforest001`, `fangornforest`, `fangornoutskirts`,
>   `rhosgobel`, `rhosgobeltower`, `dolguldur`,
>   `pathtohelmsdeep`, `helmsdeep001`, `minastirith`, `sharkeysmill`,
>   `sharkeyschamber`, `mountdoom`, `mountdoom002`. Tom Bombadil
>   has **no UTC blueprint** — author one (use a high-level commoner
>   appearance, immune-to-everything trick via `EffectImmunity` for
>   all damage types in `OnSpawn`). Old Man Willow has no UTC — clone
>   the Treant appearance (CEP creature row).
> - "Animal companion +8 all stats": animal companions in NWN are
>   spawned by `nw_s2_animalcom` at the engine level; modifying their
>   base stats permanently means scripting an `OnSpawn` override that
>   `ApplyEffect`s an `EffectAbilityIncrease` per stat. Workable.
> - "Terrain-specific passive regeneration": OnEquip script reads
>   `GetAreaTransitionTarget`/area tag prefix and applies an
>   `EffectRegenerate` matching the biome.

---

### 🏹 RANGER — *The Uncrowned Path*
**Theme:** Walks in Aragorn's footsteps, mastering the wild lands and eventually claiming a destiny.

| Level | Quest | Summary |
|---|---|---|
| 1 | *Strider's Watch* | First patrol out of Bree; track a Nazgûl's passage and survive |
| 8 | *Weathertop Ruins* | Clear Amon Sûl of Orc squatters and discover old Dúnedain cache |
| 15 | *Mirkwood Passage* | Guide a merchant caravan through Mirkwood using only natural signs |
| 22 | *The Angle of the Dúnedain* | Find the hidden Ranger camp; earn acceptance by completing three trials |
| 30 | *Ithilien Ambush* | Command Faramir's Rangers in a coordinated ambush on a Haradrim supply column |
| 38 | *The Paths of the Dead — Scouting* | Advance-scout the Paths alone; resist fear effects, map the route for the army |
| 46 | *Wild Lands of Rhûn* | Track an emissary of Sauron through the wild East; capture or kill before he recruits more Easterlings |
| 55 | *Reuniting the North* | Rally scattered Northern Dúnedain clans to ride south; requires visiting five locations |
| 60 | *The King's Standard* | Plant Aragorn's standard on the walls of the Pelennor; hold it against three champion waves |
| **REWARD** | *Anduril's Echo* | +15 longsword, +8 STR/DEX split (+4 each), +2d6 vs Evil-subtype, on-crit: Fear (DC 24), glows with script-runes |

> **Implementation:**
> - Areas: `bree`, `weatherhills`, `mirkwoodwest`, `mirkwoodcentral`,
>   `mirkwoodeast`, `rangerwaystation`, `hennethannun`,
>   `hennethannun002`, `dunharrow`, `forgottenking`, `harad`,
>   `roadtoharad`, `thepelennorfield`. Aragorn
>   (`aragornsonofarat.utc.json`) for handout.
> - **Rhûn does not exist** — substitute Cardolan
>   (`cardolan.are.json`) or Rhudaur (`thenorthdowns001.are.json`),
>   reskin via dialogue framing, or build a new area.
> - "Faramir's Rangers" — no Faramir UTC; clone Aragorn or a generic
>   Dúnedain.
> - "+2d6 vs Evil-subtype": stock weapon property
>   "Damage Bonus vs. Alignment Group: Evil 2d6" — fully supported.
> - "On-crit: Fear DC 24": "On Hit: Fear (DC X)" stock property; pick
>   nearest CostTable row to DC 24.

---

### ✝️ CLERIC — *Flame of Anor*
**Theme:** A servant of the divine light (Valar-flavored) combating the spiritual corruption of Morgoth's legacy.

| Level | Quest | Summary |
|---|---|---|
| 1 | *Light in the Barrow* | Exorcise a Barrow-wight from a fresh burial mound near the Shire |
| 8 | *The Houses of Healing* | Triage wounded soldiers in Minas Tirith; use healing spells under time pressure |
| 15 | *Shadows in Moria* | Consecrate Balin's Tomb and put the dead Dwarves to rest |
| 22 | *The Nazgûl's Taint* | Purify a village where a Ringwraith passed; cleanse 5 NPCs of Black Shadow disease |
| 30 | *Earendil's Light* | Recover a phial of starlight from Rivendell's vaults; deliver it to a besieged lighthouse |
| 38 | *Sauron Was a Maia* | Confront the theological truth: channel Valar-granted power to temporarily weaken a Nazgûl in combat |
| 46 | *The Unlight of Ungoliant* | Travel to Nan Dungortheb; oppose a spawn of Ungoliant threatening to devour a Silmaril-shard |
| 55 | *Lighting the Beacons* | Magically reinforce all seven Beacon-fires of Gondor against Mordor-shadow dampening |
| 60 | *Voice of the Valar* | Channel the full light of the Two Trees' memory into the Black Gate's shadow-wall |
| **REWARD** | *Narya's Warmth* (replica) | +15 mace, +8 WIS, Turn Undead +6 levels, 3×/day *Mass Heal* (20-ft burst), aura: allies within 10ft get +2 saves |

> **Implementation:**
> - Areas: `thebarrowdowns`, `minastirith`, `thehouseofhealin`,
>   `balinstomb`, `chamberofrecords`, `rivendell`,
>   `templeofilluvata`, `thealtar`, `thehallsoftruth`, `blackgatge`.
> - "Cleanse 5 NPCs of Black Shadow disease": set
>   `EffectDiseaseEFFECT_DISEASE_RED_SLAAD` (or any custom disease) on
>   5 spawned commoners; player's Cure Disease removes it; on each
>   removal, increment `GetLocalInt(oPC, "ne_purified")`.
> - **Nan Dungortheb does not exist** — author or skip.
> - "Aura: +2 saves to allies in 10ft": this is a stock property
>   (`Aura: Save vs. Mind Effects` etc.) but only for specific save
>   subtypes. A generic +2 to all saves needs an OnEquip persistent
>   AoE script.

---

### 🛡️ PALADIN — *Oath-Sworn to the West*
**Theme:** A knight of Gondor who embodies the last honour of Númenór against total darkness.

| Level | Quest | Summary |
|---|---|---|
| 1 | *The Oath of the Citadel* | Take formal knightly vows before the White Tree; symbolic/intro quest |
| 8 | *Ride to the Aid of Rohan* | Escort a dying Rohirric messenger back to Edoras with critical intelligence |
| 15 | *Oathbreakers' Curse* | Investigate a Gondorian knight who broke his word; help him find redemption or condemn him |
| 22 | *The Fallen Steward* | Denethor's paranoia is spreading; resist his unjust orders while keeping honour intact (alignment checks) |
| 30 | *Charge of the Rohirrim* | Lead a mounted charge through Mordor's flank; protect civilians during the breakthrough |
| 38 | *Eowyn's Example* | Partner with Éowyn against the Witch-king's lieutenants; she teaches you her strike |
| 46 | *No Living Man* | Face an avatar of the Witch-king in single combat; your Lay on Hands is the only in-combat healing |
| 55 | *The Last Alliance* | Forge a new Last Alliance by personally convincing three faction leaders to commit troops |
| 60 | *Until the World Is Healed* | Stand at the vanguard of the final assault; your Aura of Courage buffs the entire server zone |
| **REWARD** | *Fornost's Promise* | +15 bastard sword, +8 CHA, Divine Shield uses ×2/day, Smite Evil deals +5d6 bonus damage, on-kill: +1 temporary HP stack (max 30) |

> **Implementation:**
> - Areas: `minastirith`, `minastirithgates`, `edoras`, `theodenshall`,
>   `dunharrow`, `helmsdeep001`, `thepelennorfield`, `osgilbridge`.
>   Eowyn (`eowyntheshieldma.utc.json`, tag `EowyntheShieldmaiden`),
>   Theoden (`theoden002.utc.json`), Witch King (`witchking.utc.json`).
> - **No mounts in stock NWN** — "mounted charge" must be flavour-only
>   (or use NWN:EE 1.74's mount system if enabled in the module's
>   `Mod_MinGameVersion`). Inspect `module.ifo.json` for
>   `Mod_HorseEnabled` (added in EE).
> - "Smite Evil +5d6 bonus": NWN's smite already adds CHA mod ×
>   class level; no item property modifies it. Implement as item
>   on-hit: when target is Evil, `ApplyEffect 5d6 divine`.
> - "On-kill +1 temporary HP stack to 30": OnHitCastSpell with a custom
>   spellscript that stacks `EffectTemporaryHitpoints(1)` capped at 30
>   via local count.

---

### 🗺️ BARD — *Tales That Live Forever*
**Theme:** A loremaster whose music literally shapes reality, echoing Ainulindalë.

| Level | Quest | Summary |
|---|---|---|
| 1 | *A Song for Bilbo* | Perform at Bilbo's 111th birthday; impress 5 of 7 hobbits to pass |
| 8 | *The Lay of Lúthien* | Learn a fragment of Lúthien's song from an Elvish elder; perform it to calm a maddened Ent |
| 15 | *Music in Moria* | Play to distract Orc sentries while allies move through; rhythm mini-game mechanic |
| 22 | *Sorrow of the Elves* | Witness Galadriel's lament; transcribe it accurately to unlock a bardic power |
| 30 | *The Word-Hoard of Rohan* | Recover lost Rohirric saga-scrolls from a Dunlending war-chief's hall through persuasion or combat |
| 38 | *Ainulindalë Echo* | Harmonize with an ancient stone in Eregion that still resonates with the Music of Creation |
| 46 | *Counter-Song* | Use bardic music to disrupt Sauron's will-suppression field over a slave camp in Mordor |
| 55 | *Last Song of Númenór* | Recover and perform the last recorded song of Númenór before its destruction; triggers mass morale buff on server |
| 60 | *The Song That Unmakes* | Weave all learned musical fragments into a single performance that cracks Barad-dûr's foundation |
| **REWARD** | *Maglor's Lament* | +15 instrument (usable as club/quarterstaff), +8 CHA, Bardic Music effects doubled in radius and duration, unique song: *Echo of Eru* — 1×/day mass +4 all stats for 1 min |

> **Implementation:**
> - Areas: `shirebilbohouse`, `bagend001`, `lothlorien`,
>   `morialevel1cente`, `dunland`, `dunlandwarparty`, `mountdoom`.
>   Bilbo (`bilbobaggins.utc.json`), Galadriel (`galadriel.utc.json`).
>   **Eregion does not exist** — substitute `ruinsofannuminas`.
> - "Rhythm mini-game": dialogue with timed branches (`DelayCommand`
>   removes the correct option after N seconds; the engine has no
>   true timed UI, so use sequential prompts).
> - "Bardic Music doubled radius and duration": NWN's bardic music is
>   spell #411 (Curse Song) etc., backed by `nw_s2_bardsong.nss`.
>   Modifying scope requires editing that include script and
>   recompiling — feasible (it's already in the module's `*.nss`
>   tree under standard names) but global to all bards. Alternative:
>   item property `Bonus Feat: Lasting Inspiration` (CEP feat, may not
>   exist in this module).

---

### 🐾 MONK — *The Empty Hand of the West*
**Theme:** A wandering ascetic whose martial discipline echoes the traditions of the Men of the Mountains.

| Level | Quest | Summary |
|---|---|---|
| 1 | *Feet on Stone* | Traverse the Misty Mountains pass without equipment in a blizzard; endurance checks |
| 8 | *Training with the Dúnedain* | Learn unarmed combat discipline from a Ranger hermit near Weathertop |
| 15 | *The Troll-Hoard* | Clear a troll lair with no weapons (trolls eat gear); pure unarmed combat |
| 22 | *Stillness in Lothlórien* | Meditate for an in-game hour while Elves test your will; resist random distraction attacks |
| 30 | *The Spider's Web* | Navigate Shelob's lair using only your body and senses (all gear suppressed in zone) |
| 38 | *Wrestling the Balrog's Shadow* | A lesser shadow-spawn of Durin's Bane: your fists are the only weapons that can harm it |
| 46 | *Iron Fists in Mordor* | Endure the crushing despair of Mordor's will-sapping field through pure constitution |
| 55 | *The Empty Throne* | Stand vigil alone at the throne of Minas Tirith for one hour against waves of spectral challengers |
| 60 | *The Hand That Needs No Ring* | Destroy a lesser Ring-replica through sheer force of will and body |
| **REWARD** | *Hands of Manwë* | Unarmed attacks count as +15, +8 STR and CON split (+4 each), Stunning Fist DC +6, on-crit: Paralysis (DC 22), immunity to Fear/Despair effects |

> **Implementation:**
> - Areas: `mistymountainsa`, `mistymountainsb`, `weatherhills`,
>   `thetrollshalls`, `lothlorien`, `lothlorienflets`,
>   `shelobslair`, `thebalrogofmoria`, `theabyssofmoria`,
>   `mountdoom`, `minastirith`, `theodenshall`. Balrog
>   (`thebalrog.utc.json`).
> - **"All gear suppressed in zone"** — there is no engine flag for
>   this; implement on `OnAreaEnter` by `CopyItem` -ing the PC's
>   equipment into a stash chest, or via `SetIdentified` /
>   `SetItemCursedFlag` tricks. Cleaner: a custom robe placeable that
>   strips on entry and a chest at the exit that returns gear (used
>   already by stripping puzzles in other modules).
> - "Unarmed +15": NWN's unarmed strike is the *gloves* slot. Create a
>   UTI with BaseItem=Gloves and weapon-equivalent properties
>   (Enhancement +5 + typed damage bonuses). The "+15 unarmed" framing
>   is fine descriptively.
> - "Stunning Fist DC +6": no stock item property modifies feat DCs.
>   Substitute "Bonus Feat: Improved Stunning Fist" if available, or
>   stack `Ability Bonus: Wis +5` (Stunning Fist DC keys off Wis).

---

### 🔮 SORCERER — *Blood of the Elder Days*
**Theme:** A descendant of Númenórean mage-kings whose power is inherited, not learned, and increasingly dangerous.

| Level | Quest | Summary |
|---|---|---|
| 1 | *The Spark Unasked* | A spell fires without casting in a crisis; investigate the bloodline |
| 8 | *Forlong's Genealogy* | Trace your character's lineage through Gondorian records; Lore checks |
| 15 | *Wild Magic in Rhudaur* | Ruined Númenórean towers amplify your power unpredictably; navigate a dungeon with random spell surge effects |
| 22 | *The Temptation of Annatar* | A vision of Sauron-as-gift-giver offers to focus your power; resist (Will save chain) or briefly gain power at cost |
| 30 | *Mage-Blood Duel* | A rival sorcerer with corrupted Númenórean blood challenges you; winner claims the loser's power-memory |
| 38 | *The Lost Palantír Vision* | Accidentally link with a Palantír; survive a mental assault from Sauron while extracting useful intelligence |
| 46 | *Sunder the Binding* | Your blood resonates with the One Ring's frequency — use this to shatter one of the Nine's rings of power |
| 55 | *Dragon-Fire Memory* | Commune with Smaug's dying fire-spirit to absorb a fragment of primordial flame into your spells |
| 60 | *The Inheritance Unleashed* | Cast without limit for 5 minutes (cooldowns removed) to destroy the Black Gate's magical cornerstone |
| **REWARD** | *Sceptre of Annúminas* | +15 rod (usable as club), +8 CHA, Spell DC +3 all schools, Metamagic feats cost 1 less spell slot, 1×/day *Delayed Blast Fireball* auto-maximized (20d6) |

> **Implementation:**
> - Areas: `minastirith`, `cardolan`, `thenorthdowns001`,
>   `ruinsofannuminas`, `theruinsofdale`, `thelonelymountai`,
>   `lonelymountainma`, `nazgulguildhouse`, `blackgatge`. **Smaug
>   blueprint missing** — check CEP for a Red Wyrm appearance and
>   author one. The "spirit" form can use `EffectVisualEffect` of a
>   fire genasi/fire elemental.
> - "Cast without limit for 5 minutes": script the *Sceptre's* on-use
>   ability to call `RestoreSpellSlots` repeatedly on a 6s heartbeat
>   for 50 heartbeats; suppress the ApplyEffectToObject of fatigue.
> - "Spell DC +3 all schools": **not stock** — see capstone caveat at
>   the top of this section. Replace with `Spell Penetration +5` or
>   per-school DC bumps.
> - "Metamagic 1 slot cheaper": no engine support. Drop or replace
>   with `Bonus Spell Slot of Level 9` (stock).

---

---

## 📍 LOCATION-SPECIFIC QUESTS

---

### 🏔️ THE MISTY MOUNTAINS

**[One-Off] Goblin-Town Throne** *(Lvl 18)*
Infiltrate Goblin-Town, assassinate the Great Goblin's successor, and plant a false succession document to trigger a civil war that weakens Orc raids on the pass for 7 real-world days (server-wide buff).
> **Implementation:** Areas in place — `goblintownmainha.are.json`,
> `goblintownwarren.are.json`, `goblingategreate.are.json`,
> `goblingatelesser.are.json`, `goblingatemines.are.json`. Server-wide
> buff: `SetCampaignInt("homerlotr","goblin_civil_war_until",
> <unix-ts + 7*86400>)`; pass area `OnEnter` checks the value and
> halves Hostile spawn counts when active.

**[Daily] Pass the Pass** *(Lvl 10+)*
Escort a merchant caravan through the High Pass before nightfall. Stone-giants appear at higher difficulty tiers. Reward scales with difficulty selected.
> **Implementation:** Areas: `mistymountainsa.are.json`,
> `mistymountainsb.are.json`, `foothillsofthemi.are.json`. Difficulty
> selection in opening dialogue; gold reward = `nDiff * 200`.
> Stone-Giant: clone Hill Giant UTC with appearance=row 158 (Stone
> Giant) if CEP exposes it.

**[Weekly] Mithril Seam** *(Lvl 28+)*
A new mithril vein has been located in the deep mines. Compete (PvE race or PvP depending on server flag) to claim it before the Balrog's lingering heat-wraiths seal the passage. First player/group gets a mithril ingot crafting component.
> **Implementation:** Use `theabyssofmoria.are.json` /
> `thebalrogofmoria.are.json`. "First-takes-it" semantics: a single
> placeable's `OnUsed` script `CreateItemOnObject("mithril_ingot",
> oUser); SetCampaignInt(... "mithril_claimed_week_<weekNo>", 1)`,
> then despawn the placeable. Resets weekly via the `Mod_OnHeartbeat`
> script comparing `GetCalendarMonth/Day` to the stored stamp.

---

### 🌲 FANGORN FOREST

**[One-Off] The Thirteenth Ent** *(Lvl 32)*
An Ent who was present at the first Entmoot has gone completely tree-still. Discover why (he has witnessed something terrible). Restore him through nature lore, music, or druidic magic. Reward: *Ent-draught Flask* (permanent +1 STR/CON, one-time use item).
> **Implementation:** `fangornforest.are.json` /
> `fangornoutskirts.are.json`. Restore-method branch: dialogue checks
> `GetLevelByClass(CLASS_TYPE_DRUID)`/`BARD`/`Lore skill`. Permanent
> stat item: UTI with `Cast Spell: Polymorph Self` swapped for a
> custom spellscript that calls `ApplyEffectToObject(... ,
> EffectAbilityIncrease(...), DURATION_TYPE_PERMANENT)` then
> `DestroyObject(oItem)`.

**[Daily] Lumber Runners** *(Lvl 15+, Evil-aligned only)*
Smuggle harvested Fangorn timber past Ent patrols to an Isengard factor. Each success slightly advances the Isengard war machine (server-state variable).
> **Implementation:** `isengardouterrim.are.json`. State var:
> `SetCampaignInt(GetModule(), "isengard_warmachine", n+1)` (module
> scope, not per-PC). Read at `helmsdeep001.are.json` `OnEnter` to
> scale the Helm's Deep wave count.

**[Daily] Ent-Watch** *(Lvl 15+, Good-aligned only)*
Counter the above — detect and stop Lumber Runners. Each success rolls back the Isengard variable.
> **Implementation:** Same var, `n-1` per success, clamped ≥ 0. Quest
> only offered if `GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD`.

> 💡 *These two daily quests create a persistent server-state tug-of-war affecting whether Helm's Deep event spawns at Hard or Normal difficulty.*

---

### 🕸️ MIRKWOOD

**[Weekly] The Halls of Thranduil — Jailbreak** *(Lvl 22+)*
**Good:** A Dwarven merchant has been unjustly imprisoned; negotiate or sneak them out.
**Evil:** A Nazgûl spy is imprisoned; break them out through violence.
Both versions: same dungeon layout, opposite objectives, opposite rewards.
> **Implementation:** `thranduilshall.are.json` exists. Two parallel
> quest tags (`thranduil_good`, `thranduil_evil`) gated by alignment;
> the "prisoner" UTC swaps based on which quest is active. Spawn
> `prison.are.json` content variant on entry.

**[One-Off] Smaug's Lingering Curse** *(Lvl 40)*
Smaug is dead, but his dying curse still festers in Laketown's water supply. Trace it to a corrupted Dragon-shrine in Mirkwood's south. Reward: *Scale of the Last Drake* — crafting component for Dragon-Touched armor.
> **Implementation:** `laketownthetipss.are.json` and
> `mirkwoodcentrals.are.json`. Crafting: combine via a smith NPC's
> dialogue (no item-combination crafting in stock NWN — use NPC dialog
> that consumes ingredient items via `DestroyObject` and returns a
> prepared armor UTI).

**[Daily] Spider Silk Harvest** *(Lvl 12+)*
Kill Mirkwood spiders and harvest silk. Silk has three uses: crafting, selling to Good factions (they use it for rope), or selling to Evil factions (alchemical ingredient). Dynamic pricing based on server-wide supply.
> **Implementation:** `mirkwoodwest.are.json` / `mirkwoodcentrale`.
> Spider OnDeath: `CreateItemOnObject("silkbolt", oPC)`. Dynamic
> price: NPC merchant's buy dialogue computes
> `gp = base_gp - SetCampaignInt(... "silk_supply") * 2` (clamp to
> floor). Increment supply on each NPC sale; decrement weekly.

---

### ⛰️ MORIA (KHAZAD-DÛM)

**[One-Off] The Twenty-First Hall** *(Lvl 36)*
Full dungeon crawl to the Chamber of Mazarbul. Recover Balin's book, then survive the ambush that follows its disturbance. Party of 4 recommended. Reward: *Balin's Seal* (key to unlocking a Dwarven crafting master).
> **Implementation:** `chamberofrecords.are.json` (Mazarbul) and
> `balinstomb.are.json` already exist — and there is already a
> journal quest `Elrond's Request` referencing Balin's expedition.
> Tie new quest into that thread or split off via `SetLocalInt`.

**[Weekly] Durin's Bane Remnant** *(Lvl 50+)*
The Balrog is dead, but a fragment of its fire-essence has coalesced in the lowest deeps. Extinguish it before it reforms. Server-wide event: if not completed within the weekly window, fire-wraiths begin appearing in Moria's upper levels for all players.
> **Implementation:** `thebalrogofmoria`/`theabyssofmoria` already in
> place; Balrog UTC `thebalrog.utc.json` reusable as boss. Fire-wraith
> spawns gated on `GetCampaignInt(GetModule(), "balrog_remnant_unbeat",
> 0)` — set to 1 by a weekly heartbeat if not cleared.

**[Daily] Claim the Deeps** *(Lvl 20+)*
Faction control quest. Good players fortify a room with Dwarven runes. Evil players attempt to desecrate it. Room control awards crafting table access for the controlling faction until next reset.
> **Implementation:** `dwarrowdelfea001.are.json` /
> `dwarrowdelfeast.are.json`. Control state =
> `SetCampaignInt(GetModule(), "deeps_control", 1=good 2=evil 0=neutral)`;
> reset with daily heartbeat. Crafting table UTP `OnUsed` checks
> alignment vs control state.

---

### 🌊 THE GREY HAVENS

**[One-Off] Last Ship's Cargo** *(Lvl 55)*
Círdan asks you to load a final ship before a great Elf-lord departs — but agents of Sauron are sabotaging the cargo (Elvish artifacts that cannot fall into shadow). Protect the loading. Reward: *Shipwright's Blessing* (permanent water-breathing + swim speed).
> **Implementation:** **Grey Havens not in module** — author a new
> coastal area or rebrand `hiddenport.are.json`. Círdan needs a new
> UTC. NWN has no swim mechanic — substitute "Movement Speed +10%"
> permanent property and `Immunity: Drowning` (engine has no drown);
> reward stays flavour-only.

**[Daily] Harbour Watch** *(Lvl 18+)*
Guard the Haven's docks from Corsair scouts at night. Difficulty scales with how many Evil players have recently completed Corsair quests (server variable).
> **Implementation:** Same area gap. Difficulty scaling reads
> `GetCampaignInt(GetModule(), "corsair_pressure", 0)` and spawns
> `n+1` Hostile-faction Corsairs; `corsair_pressure` increments on
> evil-faction "Sacking of Pelargir" completions and decays daily.

---

### 🌋 MOUNT DOOM / MORDOR

**[One-Off — Endgame] Cracks of Doom** *(Lvl 58–60)*
The ultimate raid-style quest (up to 6 players). Cross the Plateau of Gorgoroth, survive Shelob's Pass, climb the mountain under constant Nazgûl aerial assault, and reach the Chamber of Fire. Final objective is variable: destroy an artifact, ignite a forge, or close a Shadow-Gate depending on server campaign state.
> **Implementation:** `mountdoom.are.json`, `mountdoom002.are.json`,
> `cirithungol.are.json`, `thecirithungolpa.are.json`,
> `shelobslair.are.json`. Mode: `GetCampaignInt(GetModule(),
> "endgame_mode", 0)` chooses the final-room variant. Up-to-6 players
> = NWN's per-area party limit is governed by `Mod_PVPSetting` and
> server cap; treat as group quest, not raid instancing (no
> instancing in stock NWN).

**[Weekly] Mordor Forage** *(Lvl 40+, Evil only)*
Scavenge rare volcanic minerals near active lava flows. The Balrog-kin patrol these areas. High-risk, high-reward — yields unique crafting components unavailable elsewhere.
> **Implementation:** `mountdoom002.are.json`. Lava damage = trigger
> `OnEnter` applying `EffectDamage(d6, FIRE)`. Rare component =
> stacking UTI used as a key in a `Mod_OnAcquirItem`-style craft
> conversation.

---

---

## 🃏 WILDCARD QUESTS

*Unexpected, weird, fun, or mechanically creative quests that don't fit neat categories.*

---

**[One-Off] Sméagol's Side** *(Lvl 20)*
Play as Gollum's conscience — the quest is presented entirely from his perspective with split-personality dialogue choices. Each choice swings an internal Good/Evil meter. End state determines whether Gollum later aids or betrays a server-wide event. No combat. Pure narrative. Reward: *Riddle-Ring* (unique ring with +5 to all mental skills, one quirky curse: -2 CHA permanently).
> **Implementation:** Pure dialogue in a custom dlg attached to a new
> "Sméagol's mind" placeable; meter = `SetLocalInt(oPC, "smeagol_meter",
> n)`. Gollum UTC already exists. Persist final state to
> `SetCampaignInt(GetModule(), "smeagol_alignment", n)` — read by the
> `Cracks of Doom` final-room script.

**[One-Off] The Watcher in the Water** *(Lvl 30)*
Fish near the Gate of Moria. Hook something. It fights back. It keeps fighting back. Escalating combat encounter that begins with a lake trout and ends with the Watcher's juvenile spawn (full boss fight). Reward: *Angler's Pride* (+10 Luck bonus item, cosmetic fishing rod off-hand).
> **Implementation:** `thegatesofmoria.are.json`. Use a placeable
> "fishing spot" UTP with sequential `OnUsed`: 1st use spawns lake
> trout, 2nd → octopus tentacle, 3rd → kraken-style boss (clone CEP
> giant aquatic creature). "+10 Luck" = `Skill Bonus: Lore +10` or
> `AC Bonus +1 (Deflection)` — there is no "Luck" stat in NWN.

**[Daily] Hobbit Post** *(All levels)*
Deliver a letter from the Shire to any of five possible recipients scattered across Middle-earth. Recipients and locations rotate daily. No combat required — but enemies may intercept you. Speed bonuses for fast delivery. A beloved low-pressure quest with surprisingly rich NPC dialogue. Reward: modest gold + occasional rare "misdelivered parcel" loot table.
> **Implementation:** All map zones present — pick five recipients
> across `bree`, `rivendell`, `edoras`, `minastirith`,
> `thelonelymountai`. Daily rotation = `(GetCalendarDay() %
> 5)` selects which recipient is "today's". `GetTimeSecond`-based
> bonus gold for fast delivery. Loot table: a `treasure_post` UTI
> chest opened on completion with `Random()` -picked rewards.

**[Weekly] The Riddle Game** *(Lvl 1+)*
Find Gollum in a hidden cave. Play the Riddle Game. It's a full trivia/puzzle minigame of 7 riddles drawn from Tolkien's lore. Win: *Gollum's Token* (trade-in for a random rare item). Lose: fight your way out.
> **Implementation:** `breecave.are.json` or `darkcavern.are.json`.
> Gollum UTC reusable. Riddle = pure dialogue tree; track correct
> answers via `SetLocalInt`; ≥5/7 correct = win. Random reward via
> `treasure_riddle` chest.

**[One-Off] Concerning Hobbits — The Genealogy Conspiracy** *(Lvl 5)*
The Hobbiton records office has been ransacked. Three different parties want to claim a disputed inheritance. Investigate, follow clues, and adjudicate — entirely through conversation skill checks. The "correct" answer changes each server season. Reward: *Bag End Deed* (cosmetic player housing access in the Shire).
> **Implementation:** `shirehobbiton001.are.json`,
> `shirebilbohouse.are.json`, `bagend001.are.json`. "Player housing"
> needs a per-PC instanced area — NWN has no instancing; the simplest
> fix is a single shared "Bag End" interior whose OnEnter checks
> `GetCampaignInt(GetModule(),"bagend_owner_id")` and kicks anyone
> else out. Seasonal answer: `GetCalendarMonth() / 3` indexes the
> branch.

**[One-Off] Bombadil's Errand** *(Lvl 1 — but scaled to effectively be immune to level)*
Tom Bombadil asks you to return a lost feather to a specific bird somewhere in the Old Forest. Sounds trivial. The Old Forest is rearranging itself. The bird moves. Time dilates oddly. The quest is mechanically whimsical and slightly haunting. Tom's magic makes all your abilities irrelevant — problem-solving only. Reward: *Yellow Feather* (equippable cosmetic, grants immunity to fear — because Tom's world has no fear in it).
> **Implementation:** `oldforest001.are.json`. Bombadil has no UTC —
> author one. "Old Forest rearranges": four area transitions placed in
> the same area can be `SetTransitionTarget`-rewritten on heartbeat to
> point to varying destinations. "Abilities suppressed": apply
> `EffectCutsceneDominated` or strip equipment as in the Monk capstone
> pattern. *Yellow Feather*: BaseItem=Cloak/Helm with
> `Immunity: Fear`.

**[Weekly] Ents Don't Hasty** *(Lvl 25+)*
An Ent wants to tell you about something important. It takes the entire weekly window (7 days) of periodic check-ins to finish his story. Each day reveals one sentence. At the end: a piece of ancient knowledge that grants a unique passive for the following week.
> **Implementation:** `fangornforest.are.json`, Treebeard UTC.
> Per-day gate: `GetCampaignInt(... "ent_story_day", oPC)` increments
> only if `GetCalendarDay() != GetCampaignInt(... "ent_last_day")`.
> Final reward = a 7-day buff item that destroys itself after duration.

**[One-Off] The Istari's Bet** *(Lvl 45)*
Gandalf and Radagast have made a wager about whether a mortal can cross the Brown Lands and Emyn Muil solo, without magical aid, in under one in-game day. You are the wager. No teleports, no summons, no magical items — everything suppressed. Navigation and endurance only. Winner of the bet sends you a reward by Hobbit Post afterward.
> **Implementation:** `emynmuil.are.json`, plus
> `nindalf.are.json`/`dagorlad.are.json` as the Brown Lands.
> "Everything suppressed": OnAreaEnter — same item-stash trick as the
> Monk capstone. `GetTimeHour()` - based 24-hour clock check.

**[One-Off] Ungoliant's Hunger** *(Lvl 52)*
A rift in Nan Dungortheb releases a fragment of Ungoliant's unlight — a sphere of total darkness 30 feet wide that devours light, color, and eventually life. You have torches. They won't help. You have to drive the unlight back using reflected moonlight channeled through mirrors salvaged from a ruined tower. Pure puzzle quest with lethal timer. Reward: *Phial of Counter-Darkness* (3×/day Daylight as an instant action).
> **Implementation:** Nan Dungortheb absent — author area or rebrand
> `eredduathroada.are.json`. "Mirror puzzle": four placeables each
> with `OnUsed` storing a rotation step; correct sequence opens an
> invisible trigger that despawns the unlight (a high-CR
> shadow-elemental clone with 95% concealment). *Phial of
> Counter-Darkness*: UTI with `Cast Spell: Daylight 3 charges/day`
> stock property — fully supported.

**[Seasonal — Server Event] The Long Winter** *(Lvl 1–60)*
Once per server season (3-month real cycle), a Great Winter descends on the north. All outdoor zones in Eriador gain cold-damage aura. NPCs begin starving. A 30-day server-wide quest chain activates: gather food, forge hearths, and ultimately hunt the Winter's source — a corrupted Valar-fragment imprisoned in an iceberg in the Bay of Forochel. All players contribute progress. Final reward: server-wide +10% XP bonus for following season + unique seasonal cosmetic items.
> **Implementation:** Bay of Forochel absent — `icequeennest.are.json`
> /`icequeenlair.are.json` are the closest existing analogue and fit
> thematically. "Module XP scale +10%" = at event end, set
> `Mod_XPScale` field of `module.ifo.json` — but **that field is
> static at module load**, not runtime. Workaround: gate XP awards
> through a wrapper `GiveXPToCreature` script that multiplies by the
> seasonal modifier. State persistence via
> `SetCampaignInt(GetModule(), "long_winter_phase", n)`.

---

---

## 🆕 NEW QUESTS (10 modules-grounded additions)

> Each quest below was authored against the actual area / NPC /
> resource set of `unpacked/`. All required areas already exist and
> are referenced by ResRef. NPC blueprints noted as **(reuse)** are
> already in the module; **(new)** require authoring a new UTC.

---

**[One-Off] Ferny's Return** *(Lvl 3)*
There's an existing journal entry **Ferny's Ring** (4 stages); this is its prequel. Bill Ferny has been spotted skulking around his old house — but he's not the one doing the skulking. Investigate, expose the impostor (one of Saruman's "ruffians"), and decide whether to leave Bill's stash intact or rob it for yourself.
> **Areas:** `billfernyshouse.are.json`, `bree.are.json`.
> **NPCs:** Bill Ferny commoner (reuse from `bree.git.json`); ruffian
> impostor — clone any existing `breelocal*` and re-flag faction Hostile.
> **Hooks:** Set `SetLocalInt(oPC, "ferny_prequel", 1)` on completion;
> read by the existing **Ferny's Ring** quest's start dialogue (extra
> branch unlocking a discount on Bill's ring price).
> **Journal tag:** `ferny_return`. Stages: 1 (start), 2 (impostor
> exposed), 3 (stash decided). Stage 3 has `End=1`.
> **Reward:** 200 gp, `pickpocket_glove` (Skill Bonus: Pickpocket +2);
> if you robbed the stash, +1 to a hidden "shady" reputation tracked by
> `SetCampaignInt(... "shady", n+1, oPC)` (read by future quests).

**[One-Off] The Miller's Other Son** *(Lvl 8)*
A direct sequel to **Bree Millers Son** (already in `module.jrl.json`).
The miller is grieving — but a wandering peddler claims he saw the
*other* son alive in Tharbad's ruins, working as a thrall for some kind
of cult. True or scam?
> **Areas:** `bree`, `tharbadbridge`, `tharbadwest001`,
> `thardbadeast`. **NPCs:** miller (reuse), peddler (new commoner UTC),
> cult leader (clone any Sauron-cultist Hostile creature; tag
> `MillerCultLeader`). **Branching:** persuade / fight / let-be paths.
> Persuade DC 18 against Bluff using
> `if (d20() + GetSkillRank(SKILL_PERSUADE,oPC) >= 18)`.
> **Journal tag:** `bree_miller_son2`. **Reward:** 800 gp, +1 Cha
> tome OR `peddler_pack` (5-slot bag UTI).

**[One-Off] The Twentieth Plot of Mazarbul** *(Lvl 18)*
Inside `chamberofrecords.are.json`, a hidden codicil to Balin's book
names twenty Dwarven crypts that must be re-sealed before the wraiths
of failed expeditions return. You've cleared nineteen as part of the
existing **Elrond's Request** thread — find and re-seal the forgotten
twentieth.
> **Areas:** `chamberofrecords.are.json`, `balinstomb.are.json`,
> `morialevel1cente.are.json`, `theabyssofmoria.are.json`.
> **NPCs:** Elrond (`elrond001`, reuse) for handout; restless Dwarven
> ghost (new UTC — clone any commoner with appearance row for
> Dwarven undead). **Mechanics:** light a brazier placeable in each
> of three sub-locations (`OnUsed` increments
> `GetLocalInt(oPC,"crypt_seal")`); on `==3`, fight the wraith.
> **Journal tag:** `mazarbul_20`. **Reward:** *Seal of the Twentieth*
> (UTI: BaseItem=Amulet, Damage Reduction 5/-, Negative Energy
> Resist 10/-).

**[Weekly] The Carn Dûm Ledger** *(Lvl 28+)*
Spies in Bree report that Angmar's revived clerks are recording a
master ledger of every soul promised to the Witch-King. Steal a page
of the ledger from `carndum.are.json` — every weekly steal weakens
the Witch-King's power for the following weekly tick.
> **Areas:** `carndum.are.json`, `carndumcity.are.json`,
> `carndumthrone.are.json`, `angmar.are.json`. **NPCs:** Witch-King
> (`witchking.utc.json`, reuse); ledger keeper (new — clone
> `nazgulguildhouse` resident). **State var:**
> `SetCampaignInt(GetModule(), "carndum_ledger_pages", n+1)` per
> success; subtracted from Witch-King's HP/saves at next encounter.
> **Cooldown:** weekly per-PC via `lastdone_carndum_ledger`.
> **Journal tag:** `carndum_ledger`. **Reward:**
> *Frostbitten Page* (UTI ammo-stack, plus 3000 gp).

**[Daily] Beorn's Garden** *(Lvl 12+)*
Beorn's bee-meadow has been raided by a roving troupe of wargs. Help
clear them and harvest honey for the household; Beorn pays in food,
herbs, and one rare item from his ever-rotating stash.
> **Areas:** `beorn.are.json`, `carrok.are.json`, `carrokgreater`,
> `carroklesser`. **NPCs:** Beorn (reuse — there are
> `bearbeorning001.utc.json`, `beorning001.utc.json`,
> `grimbeorntheo001.utc.json`). **Mechanics:** kill 6 wargs (Hostile
> CR 5–7), then `ActionUseObject(GetNearestObjectByTag("HoneyHive"))`
> on three placeables. **Cooldown:** daily.
> **Journal tag:** `beorn_garden`. **Reward:** randomized from a
> `treasure_beorn` UTM/chest — honey UTI, herbs, occasional
> `bears_belt` (UTI: STR +1, AC +1).

**[One-Off] The Watcher of Tharbad Bridge** *(Lvl 20)*
A creature has nested under the broken span of Tharbad. Travellers
disappear at twilight. Investigate, lure it out with a torch, and
either slay it or pact with it to spare future merchants — your
choice locks the bridge's daylight rules for everyone.
> **Areas:** `tharbadbridge.are.json`, `thardbadeast.are.json`.
> **NPCs:** Watcher boss (new — clone any tentacled CEP creature, e.g.
> `zep_water_tent`); merchant witness (new commoner). **State var:**
> `SetCampaignInt(GetModule(), "tharbad_watcher", 0/1/2)` —
> 0=alive&hostile, 1=slain, 2=pacted; OnEnter at twilight
> (`GetTimeHour() in [18..21]`) spawns Watcher only if state==0.
> **Journal tag:** `tharbad_watcher`. **Reward:** +1 weapon
> *bridgekeeper's gaff* OR (if pacted) *shadow-glass eye* (Spot +5).

**[One-Off] The Grey Lord's Errand at Annúminas** *(Lvl 38)*
Aragorn (`aragornsonofarat.utc.json`) sends you to the ruins of
Annúminas to retrieve the Sceptre, but the ruins are alive — three
spectral kings of Cardolan dispute his claim. Win their trials
(combat / lore / vow) to recover the relic.
> **Areas:** `ruinsofannuminas.are.json`, `cardolan.are.json`,
> `gravesofthelostk.are.json`, `forgottenking.are.json`.
> **NPCs:** Aragorn (reuse); three king-shades (new UTCs cloning a
> mummy lord chassis with Undead immunities). **Mechanics:** dialogue
> trees on each shade, success increments
> `SetLocalInt(oPC, "annuminas_trial", n+1)`; on 3, sceptre placeable
> opens. **Journal tag:** `annuminas_sceptre`.
> **Reward:** *Sceptre of Annúminas (lesser)* — UTI base Rod;
> Spell Penetration +4, +1 Cha. (See capstone caveat re: spell DC.)

**[One-Off] The Empty Throne of Dol Guldur** *(Lvl 42)*
The Necromancer is gone but his throne still stains the air.
Re-consecrate (good) or claim (evil) the throne in
`dolguldurcastle.are.json`. Branching alignment quest.
> **Areas:** `dolguldur.are.json`, `dolguldur001.are.json`,
> `dolguldurcastle.are.json`, `dolguldurcast001.are.json`,
> `cavesofdolguldur.are.json`, `dolguldursmith.are.json`,
> `dolguldurcity.are.json`. **NPCs:** Radagast (reuse) hands the
> good variant; Sauron-cultist (new) hands the evil. **Mechanics:**
> place 4 wards (good) OR perform 4 desecration rituals (evil),
> then a boss fight (a corrupted shadow priest, new UTC — clone
> `sauronschosen005`). **State var:**
> `SetCampaignInt(GetModule(), "dolguldur_throne", 1=consecrated 2=claimed)`
> — read by future quests for ambient flavour.
> **Journal tag:** `dolguldur_throne`. **Reward:** *Cleansed Stone*
> (UTI amulet: Save vs. Negative +2) OR *Pact-Iron* (UTI amulet:
> Save vs. Mind-Affecting +2).

**[Weekly] Faramir's Watch** *(Lvl 32+)*
Henneth Annûn needs hands. Each weekly tour involves an Ithilien
ambush (waves of Haradrim) and one of three rotating side-objectives:
intelligence (interrogate a captive), supply (escort a caravan), or
stealth (extract without being spotted by a Nazgûl flyover).
> **Areas:** `hennethannun.are.json`, `hennethannun002.are.json`,
> `gondoremynarnen.are.json`, `emynarnen.are.json`,
> `emynarnen001.are.json`, `harad.are.json`, `roadtoharad.are.json`.
> **NPCs:** Faramir (new UTC — clone Aragorn, retag `Faramir`);
> Haradrim ambushers (existing Hostile creatures in
> `harad.are.json`'s `.git`). **Mechanics:** rotation =
> `GetCalendarDay() / 7 % 3`. **Cooldown:** weekly per-PC.
> **Journal tag:** `faramir_watch`. **Reward:**
> *Ithilien Cloak* (Hide +3, Move Silently +3) on first completion;
> 2000 gp + Ranger ammunition stacks thereafter.

**[Daily] The Last Drop at Frogmorton Inn** *(Lvl 1+, low-stakes flavour)*
Five Shire-folk are arguing in the common room of
`frogmorton001.are.json`. Settle the argument — about who actually
brewed the best ale at last year's harvest — entirely through
conversation. Reward is comically small but the dialogue tree is
rich and seasonal.
> **Areas:** `frogmorton001.are.json`. **NPCs:** five existing
> hobbits in the area's `.git` (rename via dialog references rather
> than new UTCs). **Mechanics:** pure dialogue, branches gated by
> Persuade / Lore / Bluff skills; "correct" answer rotates by
> `GetCalendarMonth()`. **Cooldown:** daily.
> **Journal tag:** `frogmorton_ale`. **Reward:** 25 gp, a stackable
> *Frogmorton Pint* UTI (heals 4 hp, makes character temporarily
> tipsy via `EffectAttackDecrease(1) + EffectSavingThrowIncrease(1)`).

---

---

## 🛡️ PRESTIGE-CLASS QUESTS

> NWN's prestige classes (with `class.2da` rows): **Arcane Archer**,
> **Assassin**, **Blackguard**, **Champion of Torm** (Divine
> Champion), **Dwarven Defender**, **Harper Scout**, **Pale Master**,
> **Purple Dragon Knight (Knight of Westernesse)**, **Red Dragon
> Disciple**, **Shadowdancer**, **Shifter**, **Weapon Master**.
>
> Each quest below is gated by `GetLevelByClass(CLASS_TYPE_<X>, oPC)
> >= 1` in the giver's starting conditional. Tagging convention:
> journal tag `pc_<class>`. Recommend a single "Prestige Trainer"
> hub NPC near `thewelloferu` (the module's entry area) where all
> giver dialogues live, gated per-class.

---

**Arcane Archer — *The Galadhrim's Marker*** *(Lvl 12+)*
A scion of Lothlórien's Galadhrim has gone missing in `mirkwoodnorth`.
Track him via three planted arrows fletched with mallorn-leaf
(placeables); each arrow gives a bearing to the next. Recover his
bow, then defend it from a Mirkwood-spider ambush.
> **Areas:** `lothlorien.are.json`, `mirkwoodnorth.are.json`,
> `mirkwoodwest.are.json`. **NPCs:** Galadriel (reuse) hands the
> quest; Galadhrim hunter (new UTC). **Reward:** *Mallorn Bow*
> (UTI longbow: Enhancement +3, Mighty +3, Massive Crit 1d6 vs Evil).
> **Journal tag:** `pc_arcanearcher`.

**Assassin — *The Quiet Heir of Carn Dûm*** *(Lvl 13+)*
A rival Angmarrim assassin claims the same contract you do. Track him
through `carndumcity` and `carndumtemple`; the quest ends in a forced
duel. **No witnesses** — area heartbeat checks for nearby PCs and
fails the quest if any non-party PC is present (rough proxy: fail if
any creature with `GetIsPC` and not in your party is in the area).
> **Areas:** `carndumcity.are.json`, `carndumtemple.are.json`,
> `carndumsmithy.are.json`. **NPCs:** rival assassin (new UTC,
> appearance human black, equip kukri). **Reward:** *Kukri of the
> Quiet Heir* (UTI kukri: Enhancement +3, On-Hit Sneak Attack proxy =
> +2d6 piercing typed damage). **Journal tag:** `pc_assassin`.

**Blackguard — *The Black Captain's Mark*** *(Lvl 14+)*
The Witch-King wishes to elevate one mortal champion to bear his
mark. Pass three trials in `nazgulguildhouse.are.json` — wanton
slaughter of innocents (commoners spawned in `bree`), profanation of
a Gondorian shrine (`templeofilluvata`), and a duel with the previous
mark-bearer. Permanent alignment shift to Evil on completion.
> **Areas:** `nazgulguildhouse`, `bree`, `templeofilluvata`,
> `thealtar`. **NPCs:** Witch-King (reuse); previous bearer (new UTC).
> **Mechanics:** alignment shift via `AdjustAlignment(oPC,
> ALIGNMENT_EVIL, 50)`. **Reward:** *Mark of the Black Captain*
> (UTI amulet: STR +1, On-Hit Doom DC 18, Negative Energy Heal +5
> hp/round in shadow areas — gated by an `OnEquip` script that
> tests area tag prefix). **Journal tag:** `pc_blackguard`.

**Champion of Torm / Divine Champion — *The Vow Renewed*** *(Lvl 14+)*
Take vows again before the White Tree in `minastirith` — but the
oath now demands a tangible deed. Hunt down a fallen knight (the
target of the existing Paladin "Oathbreakers' Curse" thread, but
this is a separate handout), and spare or smite him.
> **Areas:** `minastirith.are.json`, `minastirithtemp.are.json`,
> `gondorcrypts.are.json`. **NPCs:** Citadel chaplain (new commoner
> UTC); fallen knight (new — clone Gondor guard, alignment Evil
> Hostile). **Reward:** *Renewed Vow* (UTI bastard sword: Enhancement
> +3, Damage Bonus 1d6 vs Evil, On-Hit Daze DC 18). **Journal tag:**
> `pc_divinechampion`.

**Dwarven Defender — *The Last Hold of Khazad*** *(Lvl 14+, dwarves
only — gate on `GetRacialType(oPC) == RACIAL_TYPE_DWARF`)*
At `dwarrowdelfeast.are.json`, the last living veteran of Balin's
expedition stands alone in a sealed gate-hall. Hold the gate beside
him for ten heartbeat-minutes against three waves of Goblinoid
spawns; finish with a Cave-Troll captain.
> **Areas:** `dwarrowdelfea001.are.json`, `dwarrowdelfeast.are.json`,
> `morialevel1cente.are.json`. **NPCs:** veteran defender (new UTC —
> clone any dwarf NPC, equip waraxe + tower shield); waves drawn from
> existing `goblinb001.utc.json` and other goblin/troll Hostile UTCs
> already in `unpacked/`. **Reward:** *Khazad-aim Plate* (UTI half
> plate: Enhancement +3, Damage Resistance 5/—, AC vs Goblinoid +2).
> **Journal tag:** `pc_dwarvendef`.

**Harper Scout — *The Cipher in the Inn*** *(Lvl 6+)*
A coded message has been left at the Prancing Pony for Harper
contacts. Decipher it (a multi-step dialogue puzzle drawing on Lore
and Search skills), then deliver pieces to three contacts — one in
`bree`, one in `rivendell`, one in `lothlorien`.
> **Areas:** `theprancingpo001.are.json`, `bree.are.json`,
> `rivendell.are.json`, `lothlorien.are.json`. **NPCs:** three new
> Harper contacts (commoner UTCs, distinctive cloaks). **Mechanics:**
> Lore-skill conditional in dialogue. **Reward:** *Harper Pin*
> (UTI amulet: Listen +3, Spot +3, Lore +3). **Journal tag:**
> `pc_harper`.

**Pale Master — *The Twenty-First Tomb*** *(Lvl 11+)*
Beneath `cryptsofthelosts.are.json`, a forgotten Númenórean
necromancer left a single tome describing a binding rite. Recover
it, perform the rite (dialogue ritual with three reagent items — a
ghoul-bone, a wraith's veil, a moonless-night vial), and bind a
permanent skeletal thrall.
> **Areas:** `cryptsofthelosts.are.json`,
> `breecrypt.are.json`, `breecryptlowerle.are.json`,
> `deadmarshcrypts.are.json`. **NPCs:** thrall = engine summons via
> the Pale Master class abilities; quest just unlocks an
> `OnEquipItem` script that boosts the next summon's HP. **Reward:**
> *Tome of the Twenty-First* (UTI book-as-amulet: Save vs. Negative
> +2, Bonus Spell Slot of Level 4 (Necromancy)). **Journal tag:**
> `pc_palemaster`.

**Purple Dragon Knight (Knight of Westernesse) — *The Banner of the
West*** *(Lvl 6+)*
Lead a small column of three Gondorian guardsmen across
`thepelennorfield` to plant a banner at a forward marker —
ambushers harry you the whole way. Each guardsman survived = +1 to a
permanent "command" bonus tracked on the PC.
> **Areas:** `thepelennorfield.are.json`,
> `minastirithgates.are.json`, `osgilbridge.are.json`. **NPCs:** three
> Gondor guards (reuse `guardsofconstant.utc.json` or
> `bishobofconstant.utc.json`). **Mechanics:** survival count =
> `SetCampaignInt(... "pdk_command", n, oPC)`; command-related feats
> later read this. **Reward:** *Banner of the West* (UTI tower
> shield: Enhancement +3, AC vs. Evil +1, Aura: Save vs. Fear +2 to
> nearby allies). **Journal tag:** `pc_pdk`.

**Red Dragon Disciple — *Smaug's Scale*** *(Lvl 12+)*
A scale of Smaug remains in the ruins of `theruinsofdale.are.json`
and `thelonelymountai.are.json`, said to whisper to those of dragon
blood. Recover it, resist the whisper (Will save chain), and emerge
with your nascent draconic power awakened.
> **Areas:** `theruinsofdale.are.json`,
> `thelonelymountai.are.json`, `lonelymountainma.are.json`.
> **NPCs:** dragon-cult survivor (new UTC); the "whisper" is purely
> dialogue with a Will save check (`d20 + GetAbilityModifier(WIS) +
> base will >= 18`). **Reward:** *Scale of the Last Drake* (UTI
> amulet: Fire Resist 10/-, Damage Bonus 1d6 fire vs Cold creatures).
> **Journal tag:** `pc_rdd`.

**Shadowdancer — *Through Shelob's Web Without a Lantern*** *(Lvl
11+)*
Cross `shelobslair.are.json` from one transition to the other in
absolute darkness — every torch lit by the PC drops a `SetLocalInt`
flag failing the quest. Shelob herself patrols. Hide, Move Silently,
and shadow-jump only.
> **Areas:** `shelobslair.are.json`, `cirithungol.are.json`,
> `thecirithungolpa.are.json`. **NPCs:** Shelob (reuse
> `shelob001.utc.json`). **Mechanics:** OnAreaEnter strips torch UTIs
> via `CopyItem`; `OnSpellCastAt` for `SPELL_LIGHT` fails the
> quest. **Reward:** *Cloak of Lightless Step* (UTI cloak: Hide +5,
> Move Silently +5, Skill Bonus: Tumble +3). **Journal tag:**
> `pc_shadowdancer`.

**Shifter — *The Skin-Changer's Bargain*** *(Lvl 16+)*
At `beorn.are.json`, an aged skin-changer offers to teach you the
"true bear shape" — but only if you complete a hunt in
`mirkwoodeast.are.json` while remaining shifted into a wolf-form for
the entire trial. Triggered fail-state on un-shift before completion.
> **Areas:** `beorn.are.json`, `mirkwoodeast.are.json`,
> `carrok.are.json`. **NPCs:** Beorn (reuse); skin-changer elder (new
> UTC, clone Beorn appearance). **Mechanics:**
> `OnHeartbeat` on the area watches `GetAppearanceType(oPC)`; reverts
> to PC appearance = quest fails. **Reward:** *Skinchanger's Talisman*
> (UTI amulet: Bonus Spell Slot of Level 4 Druid, Damage Resist 5/—
> while polymorphed). **Journal tag:** `pc_shifter`.

**Weapon Master — *The Duel of Three Hundred*** *(Lvl 13+)*
A weapon master from Carn Dûm has hung a challenge in
`arena001.are.json`. Defeat three hundred opponents in succession to
match his record (read: three exhibition fights of escalating
difficulty, narratively framed as 100, 100, 100 in-fiction; mechanics
keep it sane). Each fight uses a different exotic weapon supplied by
the arena.
> **Areas:** `arena001.are.json`. **NPCs:** Carn Dûm weapon-master
> (new UTC, equip kama / kukri / dwarven waraxe in succession).
> **Mechanics:** opening dialogue strips all PC weapons via stash and
> hands the chosen exotic; victory restores gear. **Reward:** *Glory
> of the Three Hundred* (UTI scimitar: Enhancement +4, Keen, Massive
> Crit 1d6) — class-restricted to Weapon Master via UTI Use
> Limitation: Class. **Journal tag:** `pc_weaponmaster`.

---

---

## 📝 Module compatibility audit

This audit is generated against `unpacked/` as of the date this file
was edited. Quick reference for what does and doesn't ship.

### ✅ Already in the module

- **Areas (most quest locations exist).** Bree + sub-locations,
  Shire (Hobbiton, Bywater, Buckland, Frogmorton, Bag End,
  Whitfurrows), Old Forest, Barrow Downs, Trollshaws, Weathertop,
  Rivendell + Smithy, Moria (Gates, Bridge, Balin's Tomb,
  Mazarbul = chamberofrecords, Abyss, Balrog, Endless Stair),
  Mirkwood (north/west/east/central + Thranduil's Hall + Dol Guldur),
  Lothlórien + Flets, Carrock + Beorn, Erebor (Lonely Mountain) +
  Dale, Mount Gundabad, Misty Mountains + Goblin-Town, Carn Dûm /
  Angmar, Cardolan, Rhudaur (`thenorthdowns001`), Tharbad, Annúminas,
  Helm's Deep + path, Dunharrow + Forgotten King + Paths of the
  Dead implied, Edoras + Theoden's Hall, Pelennor, Minas Tirith +
  Gates + Houses of Healing + Temple, Henneth Annûn, Emyn Arnen,
  Osgiliath bridge, Cirith Ungol + Pass, Shelob's Lair, Mount Doom
  ×2, Black Gate (`blackgatge`), Dagorlad, Dead Marshes + Crypts,
  Emyn Muil, Nindalf, Mordor entry. Nazgûl Guildhouse and Dark Star
  Guildhouse exist.
- **Named NPCs.** Gandalf (`Gandalf`), Saruman (`ms_orth17`, conv
  `saurman`), Elrond (`Elrond`, conv `elrondconv`), Aragorn
  (`AragornSonofArathorn`), Treebeard (`TreeBeard`), Galadriel
  (`Galadriel`), Eowyn (`EowyntheShieldmaiden`), Theoden
  (`theoden002`), Radagast (`RadagasttheBrown`), Bilbo
  (`BilboBaggins`), Gollum (`Gollum`), Witch-King (`WitchKing`),
  Legolas (`legolas`), Gimli (`gimli`), Beorn (multiple
  `beorning*`), Shelob (`shelob001`), Balrog (`thebalrog`).
- **Frameworks.** CEP 2 (HAK list), DMFI (DM tools + dialog tokens),
  DM Wand, Bedlamson Dynamic Merchants, HGLL (Letoscript-based
  level 41–60 system), pc_export autosave.
- **Persistence.** Campaign DB via `Get/SetCampaignInt`/`String`/
  `Float` (already used by the bank system → `bankdb`).
- **Existing journal entries (11).** `p000` (intro), `Bree Millers
  Son`, `Elrond's Request`, `Feeding Tharbad`, `Ferny's Ring`,
  `Gloison's Heirloom`, `guilds`, `Ruin of Annuminas`, `rules`,
  `The Well of Souls`, `website`. New quests must use new tags;
  no collisions.
- **Module event hooks** as wired in `module.ifo.json` —
  `Mod_OnHeartbeat = bleeding`, `Mod_OnAcquirItem =
  acquireditem_tag`, `Mod_OnPlrLvlUp = mod_level`, `Mod_OnPlrRest =
  on_mod_rest`, etc. New quest hooks should chain through these
  scripts (don't replace the field — call into it from the new
  script and fall through).

### ⚠️ Partially supported / needs scaffolding

- **Faction granularity.** Only Good/Evil/Neutral globals exist.
  Realm-specific reputations need new factions added to
  `repute.fac.json` + a rep matrix. See faction-quests note.
- **Mounts.** NWN:EE supports them but the module's
  `module.ifo.json` must enable them; check `Mod_HorseEnabled`. If
  off, treat all "ride" / "mount" verbs as flavour.
- **Player housing.** No instancing. Single shared interior with an
  owner-check on `OnAreaEnter` is the practical workaround.
- **Server-wide events / variables.** Implementable via
  `SetCampaignInt(GetModule(), ...)` but no built-in scheduler —
  use the `Mod_OnHeartbeat` script (`bleeding.nss`) and add a
  daily / weekly tick comparison to `GetCalendar*()`.
- **Custom item-property bonuses.** Several capstone descriptions
  exceed stock: "+8 stat" (cap is +12 but stock items rarely allow
  more than +5), "+N caster level", "Spell DC +N all schools",
  "Sneak Attack +Nd6", "Stunning Fist DC +N". See per-class
  capstone notes for stock substitutions.
- **Time-of-day enforcement.** `GetTimeHour()` is reliable but the
  module's day length is governed by `Mod_MinPerHour` in
  `module.ifo.json`; a "30-second Will save" quest must be
  expressed in heartbeat ticks (every 6s) not real seconds.

### ❌ Not in the module — would need authoring

- **Areas:** Pelargir, Eyrie, Eregion / Ost-in-Edhil, Grey Havens,
  Bay of Forochel, Nan Dungortheb, Rhûn (proper), Brown Lands
  (could substitute `dagorlad`/`nindalf`), Pelargir, Tower of
  Cirith Ungol interior (only the pass exists). Where these are
  required, either author a new area trio (.are/.git/.gic) +
  append to `Mod_Area_list` (see CLAUDE.md), or rebrand a thematic
  substitute via dialogue framing.
- **Named NPCs:** Tom Bombadil, Old Man Willow, Faramir, Haldir,
  Cirdan, Denethor, Boromir, Mouth of Sauron, Smaug. All
  authorable by cloning a similar UTC and editing.
- **Wraith / shade family creatures** for several quests — most
  can be cloned from existing `mummyboss001` or
  `lesserbarrowwigh.utc.json`.
- **Per-quest cooldown bookkeeping** has no shared library — adding
  `quest_cd_inc.nss` with helpers
  `int IsQuestOnCooldown(string sQuest, object oPC, int nDays)` and
  `void StampQuest(string sQuest, object oPC)` is the cleanest way
  to keep daily / weekly logic out of every individual script.

### General conventions assumed by all new content here

- `module.ifo.json` → `Mod_CustomTlk` is `cep`. New quest text
  should use inline `{"0": "..."}` cexolocstrings, not new
  StrRefs.
- All new resrefs ≤ 16 lowercase characters and unique per
  resource type (CLAUDE.md "Gotchas").
- New `.git`/`.gic` placements must stay positionally synced.
- Use existing `at_NNN.nss` action / `sc_NNN.nss` conditional
  prefixes for toolset-style scripts, OR descriptive names
  (`at_dolguldur_throne_complete.nss`) — both are valid.
- Capstone reward items get a UTI use-limitation matching the
  class row in `class.2da` so wrong-class PCs can't equip them.
- For server-state variables: prefer `GetCampaignInt(GetModule(),
  ...)` (module-scoped) over per-area locals — locals reset on
  area cleanup; campaign DB persists across sessions.

### Design notes (preserved from earlier draft)

- Class questlines intentionally cross zones used by other
  quests — completing your class line opens shortcuts and dialogue
  options in location quests.
- The Isengard tug-of-war (Fangorn daily) and the Nazgûl mount
  recovery (evil one-off) are examples of **server-state
  variables** — quests whose outcomes ripple outward. Recommended
  to build 6–10 such variables as the backbone of a living-world
  feel; they all share the same `GetCampaignInt(GetModule(),
  ...)` mechanism, so adding one is cheap once the helper is
  written.
- For the +15 cap economy: class capstone rewards sit at +14/+15
  *equivalent* (enhancement +5 + typed bonuses). Daily/weekly
  quest rewards should top out around +10–+12 equivalent to
  preserve the capstone's prestige. Stock NWN's +20 BAB AC race
  matters here — keep the spread between best dailies and class
  capstones above 2 raw enhancement points so the capstones still
  feel distinct.
