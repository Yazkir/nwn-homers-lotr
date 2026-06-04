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
        // Blueprints are pre-set to Merchant faction with no event scripts, so no runtime
        // faction override is needed here.
        c.PlotFlag = true;
        c.Immortal = true;
        c.IsDestroyable = false;
        c.Lootable = false;
        StripCombatAi(c);

        bool isEnemy = Card.columnIndex >= 0;
        if (isEnemy)
        {
            // Freeze revealed enemies in place so they read as a board, not combatants.
            // Also clear the conversation the blueprint sets — paralysed enemies must not be talkable.
            c.DialogResRef = "";
            c.ApplyEffect(EffectDuration.Permanent, NwEffect.CutsceneParalyze());
        }
        else
        {
            // Allies are clickable to start the attack conversation.
            // Blueprint already has ds_attack set; redundantly assert it here for robustness.
            c.DialogResRef = DsConfig.AttackDialog;
        }

        // Map the card's life onto NWN HP so the engine's "badly wounded" / "near death"
        // states reflect card health, and snap HP back if the player ever damages the card.
        RefreshHealth();
        c.OnDamaged += RevertDamage;
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
        c.ClearActionQueue();
    }

    private void IgnoreAttack(CreatureEvents.OnPhysicalAttacked evt)
    {
        if (Creature is not { IsValid: true } c) return;
        c.ClearActionQueue();
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
