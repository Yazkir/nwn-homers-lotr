using Anvil.API;
using Anvil.API.Events;
using NWN.Core;
using NwEffect = Anvil.API.Effect;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// The NWN representation of a single engine <see cref="Card"/>: a face-down
/// statue placeable (hidden enemy) or a creature NPC (revealed enemy / hand ally).
/// All card data is surfaced through the spawned object's name + description so the
/// player reads it by examining the NPC.
/// </summary>
internal sealed class CardActor
{
    public Card Card { get; }
    public NwGameObject? Obj { get; private set; }
    public bool IsStatue { get; private set; }

    /// <summary>The current HP we last asserted on the creature; re-applied if the player damages it.</summary>
    public int DesiredHp { get; private set; }

    public NwCreature? Creature => Obj as NwCreature;

    public CardActor(Card card) => Card = card;

    /// <summary>True if this actor currently matches the card's revealed state.</summary>
    public bool MatchesReveal(bool wantStatue) => Obj != null && Obj.IsValid && IsStatue == wantStatue;

    /// <summary>Spawn (or replace) the visible object for this card at <paramref name="location"/>.</summary>
    public void Render(Location location, bool asStatue, bool playAppearVfx)
    {
        Destroy();
        IsStatue = asStatue;

        if (asStatue)
        {
            Obj = NwPlaceable.Create(CardCreatureMap.FaceDownStatue, location, false, "ds_card");
            if (Obj != null)
            {
                Obj.Name = "Face-down card";
                Obj.Description = "A face-down card. Defeat the card in front of it to reveal what lies beneath.";
            }
            return;
        }

        NwCreature? c = NwCreature.Create(CardCreatureMap.Resolve(Card), location, false, "ds_card");
        Obj = c;
        if (c == null) return;

        c.Name = CardCreatureMap.BuildName(Card);
        c.Description = CardCreatureMap.BuildDescription(Card);

        // Inert "card" creature: never dies, never wanders, never fights, never drops loot.
        c.PlotFlag = true;
        c.Immortal = true;
        c.IsDestroyable = false;
        c.Lootable = false;
        SetInertFaction(c);
        StripCombatAi(c);

        bool isEnemy = Card.columnIndex >= 0;
        if (isEnemy)
        {
            // Freeze revealed enemies in place so they read as a board, not combatants.
            c.ApplyEffect(EffectDuration.Permanent, NwEffect.CutsceneParalyze());
        }
        else
        {
            // Allies are clickable to start the attack conversation.
            c.DialogResRef = DsConfig.AttackDialog;
        }

        // Map the card's life onto NWN HP so the engine's "badly wounded" / "near death"
        // states reflect card health, and snap HP back if the player ever damages the card.
        RefreshHealth();
        c.OnDamaged += RevertDamage;
        // Attacking a neutral creature triggers an internal AdjustReputation(-100) that
        // overrides faction neutrality. Clear actions and re-assert the faction so the
        // creature never retaliates and never appears hostile after an attack.
        c.OnPhysicalAttacked += IgnoreAttack;

        if (playAppearVfx)
            c.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.Appear));
    }

    /// <summary>Refresh the displayed name/description and HP from the (possibly mutated) card.</summary>
    public void RefreshText()
    {
        if (Creature is { IsValid: true } c)
        {
            c.Name = CardCreatureMap.BuildName(Card);
            c.Description = CardCreatureMap.BuildDescription(Card);
            RefreshHealth();
        }
    }

    /// <summary>
    /// Set the creature's current HP to the card's life ratio against its natural max,
    /// so NWN's health bar / wounded states track the card. Clamped to [1, MaxHP]
    /// (dead cards are removed by BoardView.Sync; Immortal keeps the creature alive
    /// regardless). This is the engine-authoritative value we revert to on damage.
    /// </summary>
    public void RefreshHealth()
    {
        if (Creature is not { IsValid: true } c) return;
        int max = c.MaxHP;
        if (max <= 0) return;
        float ratio = Card.maxHealth > 0 ? (float)Card.currentHealth / Card.maxHealth : 1f;
        int target = (int)Math.Round(max * ratio);
        target = Math.Clamp(target, 1, max);
        DesiredHp = target;
        if (c.HP != target) c.HP = target;
    }

    private void RevertDamage(CreatureEvents.OnDamaged evt)
    {
        if (Creature is not { IsValid: true } c) return;
        if (c.HP != DesiredHp) c.HP = DesiredHp;
        // Re-assert neutral faction in case the damage tick re-triggered hostility.
        SetInertFaction(c);
        c.ClearActionQueue();
    }

    private void IgnoreAttack(CreatureEvents.OnPhysicalAttacked evt)
    {
        if (Creature is not { IsValid: true } c) return;
        SetInertFaction(c);
        c.ClearActionQueue();
    }

    /// <summary>
    /// Sets the creature to the Commoner (neutral) faction so it never appears hostile,
    /// then repairs the Commoner–PC reputation for every online player. Blueprint factions
    /// (often Hostile for enemy NPCs) are overridden here so cards are never auto-attacked.
    /// Reputation repair is needed because attacking any Commoner-faction NPC anywhere in
    /// the module permanently damages the global Commoner↔PC reputation, making these card
    /// creatures appear hostile from spawn even though their faction is set correctly.
    /// </summary>
    private static void SetInertFaction(NwCreature c)
    {
        NwFaction? faction = NwFaction.FromStandardFaction(StandardFaction.Commoner)
            ?? NwFaction.FromStandardFaction(StandardFaction.Merchant);
        if (faction is null) return;
        c.Faction = faction;

        // Repair reputation with each online PC so the card never appears hostile.
        // AdjustReputation adjusts Commoner's view of the PC faction; GetReputation
        // returns that same value so we can bring it to exactly 50 (neutral).
        foreach (NwPlayer player in NwModule.Instance.Players)
        {
            NwCreature? pc = player.ControlledCreature;
            if (pc?.IsValid != true) continue;
            int rep = NWScript.GetReputation(c.ObjectId, pc.ObjectId);
            if (rep < 50) NWScript.AdjustReputation(c.ObjectId, pc.ObjectId, 50 - rep);
        }
    }

    /// <summary>
    /// Clears the NWScript event scripts that drive combat AI (heartbeat, perception,
    /// combat round). Blueprint creatures — especially those in Good, Neutral, Evil, or
    /// Hostile factions — would otherwise perceive the player as an enemy and attack.
    /// Anvil event hooks (OnPhysicalAttacked, OnDamaged) live in NWNX's event layer and
    /// are unaffected by clearing these NWScript slots.
    /// </summary>
    private static void StripCombatAi(NwCreature c)
    {
        // NWN SetEventScript event-type integers for creature slots.
        const int EvtHeartbeat  = 0; // EVENT_SCRIPT_CREATURE_ON_HEARTBEAT
        const int EvtNotice     = 1; // EVENT_SCRIPT_CREATURE_ON_NOTICE (perception)
        const int EvtEndCombat  = 6; // EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND
        uint id = c.ObjectId;
        NWScript.SetEventScript(id, EvtHeartbeat, "");
        NWScript.SetEventScript(id, EvtNotice, "");
        NWScript.SetEventScript(id, EvtEndCombat, "");
    }

    public void Destroy()
    {
        if (Obj is { IsValid: true })
            Obj.Destroy();
        Obj = null;
    }
}
