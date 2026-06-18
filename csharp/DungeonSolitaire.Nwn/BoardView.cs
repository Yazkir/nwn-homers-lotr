using System.Numerics;
using Anvil.API;
using NLog;
using NwEffect = Anvil.API.Effect;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Renders the engine's board state as NWN objects in the Dungeon Solitaire area:
/// enemy columns at the DS_C{col}_R{row} waypoints (statues face-down, creatures
/// revealed) and the player's hand fanned around the DS_Hand waypoint. Rendering is
/// reconciliation-based — <see cref="Sync"/> brings the spawned objects in line with
/// current engine state — which is robust against the engine's mid-turn reordering.
/// </summary>
internal sealed class BoardView
{
    private static readonly Logger Log = LogManager.GetCurrentClassLogger();

    public NwArea Area { get; }

    /// <summary>Raised for each newly spawned ally creature so the session can attach its conversation handler.</summary>
    public System.Action<NwCreature>? OnAllySpawned;

    private readonly Dictionary<Card, CardActor> _actors = new();
    private readonly Dictionary<string, Location?> _locCache = new();

    public BoardView(NwArea area) => Area = area;

    public IReadOnlyDictionary<Card, CardActor> Actors => _actors;

    /// <summary>Find the card actor backing a clicked creature (for the attack flow).</summary>
    public CardActor? ActorFor(NwCreature? creature)
        => creature == null ? null : _actors.Values.FirstOrDefault(a => a.Creature == creature);

    // ── Locations ────────────────────────────────────────────────────────────
    private Location? WaypointLoc(string tag)
    {
        if (_locCache.TryGetValue(tag, out Location? cached)) return cached;
        Location? loc = NwModule.Instance.GetWaypointByTag(tag)?.Location;
        _locCache[tag] = loc;
        if (loc == null) Log.Warn($"[DungeonSolitaire] waypoint '{tag}' not found in {DsConfig.AreaResRef}");
        return loc;
    }

    private Location? ColumnLoc(int col, int row) => WaypointLoc(DsConfig.ColumnRowTag(col, row));

    private Location? HandLoc(int index, int count)
    {
        Location? baseLoc = WaypointLoc(DsConfig.HandRallyTag);
        if (baseLoc == null) return null;
        float offset = (index - (count - 1) / 2f) * DsConfig.HandSpacing;
        Vector3 p = baseLoc.Position;
        return Location.Create(baseLoc.Area, new Vector3(p.X + offset, p.Y, p.Z), baseLoc.Rotation);
    }

    private Location? GraveLoc(int index, int count)
    {
        Location? baseLoc = WaypointLoc(DsConfig.GraveyardTag);
        if (baseLoc == null) return null;
        // Stagger corpses in a tight cluster around the waypoint so they read as a heap.
        float offset = (index - (count - 1) / 2f) * 0.6f;
        Vector3 p = baseLoc.Position;
        return Location.Create(baseLoc.Area, new Vector3(p.X + offset, p.Y, p.Z), baseLoc.Rotation);
    }

    // ── Reconciliation ─────────────────────────────────────────────────────────
    public void Sync(GameEngine engine)
    {
        // Destroy any ds_card objects in the world that are not owned by this board.
        // These are orphans left by a prior session's engine thread that raced past Teardown.
        foreach (NwCreature c in NwObject.FindObjectsWithTag<NwCreature>("ds_card").ToList())
            if (_actors.Values.All(a => a.Obj?.ObjectId != c.ObjectId)) c.Destroy();
        foreach (NwPlaceable p in NwObject.FindObjectsWithTag<NwPlaceable>("ds_card").ToList())
            if (_actors.Values.All(a => a.Obj?.ObjectId != p.ObjectId)) p.Destroy();

        var desired = new Dictionary<Card, (Location loc, ActorKind kind)>();

        for (int col = 0; col < engine.EnemyColumns.Count && col < DsConfig.ColumnCount; col++)
        {
            var column = engine.EnemyColumns[col];
            for (int row = 0; row < column.Count && row < DsConfig.RowCount; row++)
            {
                Location? loc = ColumnLoc(col, row);
                if (loc != null)
                    desired[column[row]] = (loc, column[row].revealed ? ActorKind.EnemyCreature : ActorKind.EnemyStatue);
            }
        }

        var hand = engine.Hand.cards;
        for (int i = 0; i < hand.Count; i++)
        {
            Location? loc = HandLoc(i, hand.Count);
            if (loc != null) desired[hand[i]] = (loc, ActorKind.Ally);
        }

        // Defeated enemies and spent allies have been moved to the engine's Graveyard:
        // render them as a corpse pile at DS_Graveyard.
        var grave = engine.Graveyard.cards;
        for (int i = 0; i < grave.Count; i++)
        {
            Location? loc = GraveLoc(i, grave.Count);
            if (loc != null) desired[grave[i]] = (loc, ActorKind.Grave);
        }

        // Remove actors whose card left play (graveyard / exile / attacker / killed).
        foreach (Card gone in _actors.Keys.Where(c => !desired.ContainsKey(c)).ToList())
        {
            _actors[gone].Destroy();
            _actors.Remove(gone);
        }

        // Add / update the rest.
        foreach ((Card card, (Location loc, ActorKind kind)) in desired)
        {
            bool statue = kind == ActorKind.EnemyStatue;
            bool ally = kind == ActorKind.Ally;

            if (_actors.TryGetValue(card, out CardActor? actor) && actor.Obj is { IsValid: true })
            {
                if (kind == ActorKind.Grave)
                {
                    // Card just died / was spent: play the death beat and move it to the pile.
                    // Already-buried corpses are left lying where they are.
                    if (!actor.IsBuried) _ = actor.BuryAt(loc);
                }
                else if (!actor.MatchesReveal(statue))
                {
                    bool wasStatue = actor.IsStatue;
                    actor.Render(loc, statue, false);
                    if (wasStatue && !statue)
                        actor.Obj?.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.Reveal));
                }
                else
                {
                    Reposition(actor, loc, ally);
                    actor.RefreshText();
                }
            }
            else
            {
                actor = new CardActor(card);
                if (kind == ActorKind.Grave)
                {
                    // Card entered the graveyard without ever being on the board (e.g. milled
                    // from the library): spawn it straight into the corpse pose at the pile.
                    actor.Render(loc, false, false);
                    actor.SetBuriedPose();
                }
                else if (ally)
                {
                    // Allies appear at the spawn-in point and walk to their place in the hand line.
                    Location spawn = WaypointLoc(DsConfig.HandSpawnTag) ?? loc;
                    actor.Render(spawn, false, true);
                    _ = actor.Creature?.ActionForceMoveTo(loc, true);
                    actor.Creature?.FaceToPoint(ColumnLoc(2, 0)?.Position ?? loc.Position);
                    if (actor.Creature != null) OnAllySpawned?.Invoke(actor.Creature);
                }
                else
                {
                    actor.Render(loc, statue, true);
                }
                _actors[card] = actor;
            }
        }
    }

    private enum ActorKind { EnemyStatue, EnemyCreature, Ally, Grave }

    private void Reposition(CardActor actor, Location target, bool ally)
    {
        NwGameObject? obj = actor.Obj;
        if (obj is not { IsValid: true }) return;
        if (obj.Location != null && obj.Location.Distance(target) < 0.3f) return;

        if (actor.IsStatue)
        {
            actor.Render(target, true, false); // placeables can't move — re-place
        }
        else if (ally)
        {
            _ = actor.Creature?.ActionForceMoveTo(target, true);
        }
        else
        {
            _ = actor.Creature?.ActionJumpToLocation(target); // enemies snap forward as the column whittles
        }
    }

    // ── Attack animation ───────────────────────────────────────────────────────
    /// <summary>Lunge an ally onto the front of a column and flash the impact — Godot's attack beat.
    /// The ally is left at the target; the next Sync buries it (graveyard) or returns it to hand.</summary>
    public async Task AnimateAttack(CardActor ally, int columnIndex, GameEngine engine)
    {
        NwCreature? c = ally.Creature;
        if (c is not { IsValid: true }) return;

        CardActor? target = FrontEnemyActor(engine, columnIndex);
        Location? targetLoc = target?.Obj?.Location ?? ColumnLoc(columnIndex, 0);
        if (targetLoc == null) return;

        await c.ActionForceMoveTo(targetLoc, true);
        c.FaceToPoint(targetLoc.Position);
        target?.Obj?.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.MeleeImpact));
        await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.LungeSeconds));
        // No walk-back: a spent ally is moved to the graveyard by the engine, so the next
        // Sync buries it (BuryAt). Allies that an effect returns to hand are repositioned
        // to the hand line there instead. (Returning home here made spent cards look like
        // they went back to the hand.)
    }

    private CardActor? FrontEnemyActor(GameEngine engine, int columnIndex)
    {
        if (columnIndex < 0 || columnIndex >= engine.EnemyColumns.Count) return null;
        Card? front = engine.EnemyColumns[columnIndex].FirstOrDefault(card => card.currentHealth > 0);
        return front != null && _actors.TryGetValue(front, out CardActor? a) ? a : null;
    }

    public void Clear()
    {
        foreach (CardActor a in _actors.Values) a.Destroy();
        _actors.Clear();
    }
}
