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
    private int _graveCount;   // running count of corpses placed in the graveyard pile

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

    /// <summary>Absolute graveyard slot for the Nth corpse — laid out in staggered rows of
    /// five so the pile grows as a heap around the DS_Graveyard waypoint.</summary>
    private Location? GraveSlot(int slot)
    {
        Location? baseLoc = WaypointLoc(DsConfig.GraveyardTag);
        if (baseLoc == null) return null;
        int row = slot / 5, col = slot % 5;
        Vector3 p = baseLoc.Position;
        return Location.Create(baseLoc.Area, new Vector3(p.X + (col - 2) * 0.8f, p.Y - row * 0.8f, p.Z), baseLoc.Rotation);
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

        // The graveyard zone is NOT rendered here: defeated/spent cards are kept as their
        // existing actors (see MarkPendingBurial / MarchPendingToGraveyard) so they don't
        // get a duplicate body. Remove only actors whose card truly left play (exile /
        // recycled to library); never the in-flight attacker or a dead/dying body.
        foreach (Card gone in _actors.Keys.Where(c => !desired.ContainsKey(c)).ToList())
        {
            CardActor a = _actors[gone];
            if (a.PendingBurial || a.IsBuried || ReferenceEquals(gone, engine.attacker)) continue;
            a.Destroy();
            _actors.Remove(gone);
        }

        // Add / update the rest.
        foreach ((Card card, (Location loc, ActorKind kind)) in desired)
        {
            bool statue = kind == ActorKind.EnemyStatue;
            bool ally = kind == ActorKind.Ally;

            if (_actors.TryGetValue(card, out CardActor? actor) && actor.Obj is { IsValid: true })
            {
                if (!actor.MatchesReveal(statue))
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
                if (ally)
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

    private enum ActorKind { EnemyStatue, EnemyCreature, Ally }

    // ── Burial (death feedback now, march to the graveyard at end of turn) ───────
    /// <summary>Play the in-place death feedback for a card that just entered the graveyard
    /// (called from the engine's CardZoneChanged→Graveyard event). The body stays put.</summary>
    public void MarkPendingBurial(Card? card)
    {
        if (card != null && _actors.TryGetValue(card, out CardActor? a)) a.DieInPlace();
    }

    /// <summary>End-of-turn: walk every pending corpse over to the graveyard pile and lie it
    /// prone. Fire-and-forget so the bodies march in parallel.</summary>
    public void MarchPendingToGraveyard()
    {
        foreach (CardActor a in _actors.Values.Where(x => x.PendingBurial).ToList())
        {
            Location? slot = GraveSlot(_graveCount++);
            if (slot != null) _ = a.MarchTo(slot);
        }
    }

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
        if (targetLoc == null || c.Location == null) return;

        // Stop SHORT of the enemy's (occupied) tile. Pathing onto the exact tile fails and
        // ActionForceMoveTo completes instantly, which fired the damage/VFX before the ally
        // had moved. Stopping ~1.8 m short makes the walk real and complete on arrival.
        Vector3 from = c.Location.Position;
        Vector3 to = targetLoc.Position;
        Vector3 delta = to - from;
        Vector3 stopPos = delta.Length() > 1.8f ? to - Vector3.Normalize(delta) * 1.8f : from;

        _ = c.ActionForceMoveTo(Location.Create(targetLoc.Area, stopPos, targetLoc.Rotation), true);

        // Wait for real arrival (or a short timeout) before landing the blow, so the engine's
        // damage + impact VFX (gated behind this await by SubmitAttack) play on contact.
        for (int i = 0; i < 40 && c.IsValid; i++)
        {
            if (c.Location != null && Vector3.Distance(c.Location.Position, stopPos) <= 1.0f) break;
            await NwTask.Delay(TimeSpan.FromSeconds(0.05));
        }

        if (!c.IsValid) return;
        c.FaceToPoint(to);
        target?.Obj?.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.MeleeImpact));
        await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.LungeSeconds));
        // No walk-back: the spent ally stays here until the end-of-turn burial march.
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
        _graveCount = 0;
    }
}
