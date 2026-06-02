using Anvil.API;
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

        c.Name = Card.name;
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

        if (playAppearVfx)
            c.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.Appear));
    }

    /// <summary>Refresh the displayed name/description from the (possibly mutated) card.</summary>
    public void RefreshText()
    {
        if (Creature is { IsValid: true } c)
        {
            c.Name = Card.name;
            c.Description = CardCreatureMap.BuildDescription(Card);
        }
    }

    public void Destroy()
    {
        if (Obj is { IsValid: true })
            Obj.Destroy();
        Obj = null;
    }
}
