using Anvil.API;
using Anvil.API.Events;
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

        // Inert "card" creature: never dies, never wanders, never fights.
        c.PlotFlag = true;
        c.Immortal = true;
        c.IsDestroyable = false;
        if (NwFaction.FromStandardFaction(StandardFaction.Commoner) is { } commoner)
            c.Faction = commoner;

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
        if (Creature is { IsValid: true } c && c.HP != DesiredHp)
            c.HP = DesiredHp;
    }

    public void Destroy()
    {
        if (Obj is { IsValid: true })
            Obj.Destroy();
        Obj = null;
    }
}
