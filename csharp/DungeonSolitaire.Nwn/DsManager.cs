using Anvil.API;
using Anvil.API.Events;
using Anvil.Services;
using NLog;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Top-level Dungeon Solitaire service: owns the single live session, claims the
/// area for the lever-puller, gates bystanders out, clears the board when the
/// active player leaves or logs out for too long, and routes the attack
/// conversation (ds_attack) into the session.
/// </summary>
[ServiceBinding(typeof(DsManager))]
internal sealed class DsManager
{
    private static readonly Logger Log = LogManager.GetCurrentClassLogger();

    private readonly MainThreadDispatcher _dispatcher;
    private readonly HighScoreStore _scores;

    private NwArea? _area;
    private DsSession? _session;


    // Abandonment tracking for the active player.
    private double _awaySeconds;

    public DsManager(MainThreadDispatcher dispatcher, HighScoreStore scores)
    {
        _dispatcher = dispatcher;
        _scores = scores;
        // Defer scene wiring to the main thread, by which point areas/objects are loaded.
        _dispatcher.Enqueue(WireScene);
        _ = WatchAbandonment();
    }

    private void WireScene()
    {
        _area = NwModule.Instance.Areas.FirstOrDefault(a => a.ResRef == DsConfig.AreaResRef);
        if (_area == null)
        {
            Log.Error($"[DungeonSolitaire] area '{DsConfig.AreaResRef}' not found — plugin idle");
            return;
        }

        foreach (NwPlaceable lever in NwObject.FindObjectsWithTag<NwPlaceable>(DsConfig.LeverTag))
            lever.OnUsed += OnLeverUsed;

        _scores.UpdateSign();
        Log.Info("[DungeonSolitaire] wired Dungeon Solitaire area and lever.");
    }

    // ── Lever: claim / restart / deny ────────────────────────────────────────────
    private void OnLeverUsed(PlaceableEvents.OnUsed evt)
    {
        NwPlayer? pc = evt.UsedBy?.ControllingPlayer;
        if (pc == null || !pc.IsValid) return;

        if (_session is { IsAlive: true })
        {
            if (_session.ActivePlayer == pc)
            {
                pc.SendServerMessage("Restarting your game of Dungeon Solitaire...", ColorConstants.Lime);
                EndSession(announce: false);
                StartNewGame(pc);
            }
            else
            {
                pc.SendServerMessage($"{_session.ActivePlayerName} is playing Dungeon Solitaire right now. Wait for the board to clear.", ColorConstants.Orange);
            }
            return;
        }

        pc.SendServerMessage("You are now the active Dungeon Solitaire player!", ColorConstants.Lime);
        StartNewGame(pc);
    }

    private void StartNewGame(NwPlayer pc)
    {
        if (_area == null) return;
        EndSession(announce: false);

        var board = new BoardView(_area);
        var session = new DsSession(pc, board, _dispatcher, _scores, onEnded: () => { });
        session.AllyConversationHook = ally => ally.OnConversation += OnAllyConversation;
        _session = session;
        _awaySeconds = 0;
        session.Start();
    }

    private void EndSession(bool announce, string? message = null)
    {
        if (_session == null) return;
        if (announce && message != null)
            foreach (NwPlayer p in NwModule.Instance.Players)
                if (p.IsValid && p.ControlledCreature?.Area == _area)
                    p.SendServerMessage(message, ColorConstants.Yellow);

        _session.Teardown();
        _session = null;
        _awaySeconds = 0;

        // Deferred sweep: the engine background thread may have already queued Board.Sync()
        // calls that will re-spawn card actors after Teardown's Board.Clear(). Because the
        // dispatcher is FIFO, enqueueing here guarantees this runs after those stale items.
        _dispatcher.Enqueue(() =>
        {
            foreach (NwCreature  c in NwObject.FindObjectsWithTag<NwCreature> ("ds_card").ToList()) c.Destroy();
            foreach (NwPlaceable p in NwObject.FindObjectsWithTag<NwPlaceable>("ds_card").ToList()) p.Destroy();
        });
    }

    // ── Abandonment: clear the board if the active player leaves/logs out > 30s ───
    private async Task WatchAbandonment()
    {
        await NwTask.SwitchToMainThread();
        while (true)
        {
            await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.WatchTickSeconds));
            if (_session is not { IsAlive: true }) { _awaySeconds = 0; continue; }

            NwPlayer p = _session.ActivePlayer;
            bool present = p.IsValid && p.ControlledCreature is { IsValid: true } c && c.Area == _area;
            if (present)
            {
                _awaySeconds = 0;
            }
            else
            {
                _awaySeconds += DsConfig.WatchTickSeconds;
                if (_awaySeconds >= DsConfig.AbandonSeconds)
                    EndSession(announce: true, message: "The Dungeon Solitaire board fades away. A new challenger may now play.");
            }
        }
    }

    // ── Attack conversation (ds_attack) ──────────────────────────────────────────
    private void OnAllyConversation(CreatureEvents.OnConversation evt)
    {
        NwPlayer? speaker = evt.PlayerSpeaker;
        // DEBUG (round 2): trace the click path — remove once the picker opens reliably.
        Log.Info($"[DungeonSolitaire] OnAllyConversation fired: speaker={speaker?.PlayerName ?? "<null>"} " +
                 $"valid={speaker?.IsValid} sessionAlive={_session?.IsAlive} active={_session?.ActivePlayerName} " +
                 $"awaitingAlly={_session?.IsAwaitingAlly} creatureInConv={evt.Creature.IsInConversation}");

        if (_session is not { IsAlive: true }) return;
        if (speaker is not { IsValid: true }) return;

        if (speaker.PlayerName != _session.ActivePlayerName)
        {
            Log.Info("[DungeonSolitaire] OnAllyConversation: spectator — sending watch message.");
            speaker.SendServerMessage(
                $"You are watching {_session.ActivePlayerName}'s game of Dungeon Solitaire.",
                ColorConstants.Orange);
            return;
        }

        // Subscribing to OnConversation replaced the creature's default dialogue script
        // (and the DS_* blueprints carry none), so the engine never opens the picker on
        // its own — start it ourselves after seeding the per-column target names.
        // Defer the start off the event: starting a conversation from inside the
        // click-to-talk OnConversation event (mid engine-initiation) is unreliable.
        NwCreature ally = evt.Creature;
        _session.RefreshAttackTokens();
        Log.Info($"[DungeonSolitaire] OnAllyConversation: queuing ds_attack for {speaker.PlayerName}.");
        _dispatcher.Enqueue(() =>
        {
            if (speaker.IsValid && ally.IsValid)
            {
                Log.Info("[DungeonSolitaire] OnAllyConversation: opening ds_attack now.");
                speaker.ActionStartConversation(ally, DsConfig.AttackDialog, true, false);
            }
            else
            {
                Log.Warn("[DungeonSolitaire] OnAllyConversation: speaker/ally invalid at open time.");
            }
        });
    }

    // Per-column conversation handlers. Distinct script names (rather than script
    // parameters) keep the .dlg portable — no module here uses dialog ScriptParams.
    [ScriptHandler("ds_atkc1")] public ScriptHandleResult ColCond1(CallInfo i) => ColumnCondition(i, 0);
    [ScriptHandler("ds_atkc2")] public ScriptHandleResult ColCond2(CallInfo i) => ColumnCondition(i, 1);
    [ScriptHandler("ds_atkc3")] public ScriptHandleResult ColCond3(CallInfo i) => ColumnCondition(i, 2);
    [ScriptHandler("ds_atkc4")] public ScriptHandleResult ColCond4(CallInfo i) => ColumnCondition(i, 3);
    [ScriptHandler("ds_atkc5")] public ScriptHandleResult ColCond5(CallInfo i) => ColumnCondition(i, 4);

    [ScriptHandler("ds_atk1")] public void ColDo1(CallInfo i) => ColumnChosen(i, 0);
    [ScriptHandler("ds_atk2")] public void ColDo2(CallInfo i) => ColumnChosen(i, 1);
    [ScriptHandler("ds_atk3")] public void ColDo3(CallInfo i) => ColumnChosen(i, 2);
    [ScriptHandler("ds_atk4")] public void ColDo4(CallInfo i) => ColumnChosen(i, 3);
    [ScriptHandler("ds_atk5")] public void ColDo5(CallInfo i) => ColumnChosen(i, 4);

    private ScriptHandleResult ColumnCondition(CallInfo info, int col0)
    {
        ScriptHandleResult r = EvalColumnCondition(info, col0);
        Log.Info($"[DungeonSolitaire] ColumnCondition col={col0} -> {r}"); // DEBUG (round 2)
        return r;
    }

    private ScriptHandleResult EvalColumnCondition(CallInfo info, int col0)
    {
        if (_session is not { IsAlive: true }) return ScriptHandleResult.False;
        if (info.ObjectSelf is not NwCreature ally) return ScriptHandleResult.False;
        if (!_session.IsAwaitingAlly) return ScriptHandleResult.False;
        Card? card = _session.CardForCreature(ally);
        if (card == null || DsSession.IsInsteadOfAttack(card)) return ScriptHandleResult.False;
        return _session.ColumnHasEnemies(col0) ? ScriptHandleResult.True : ScriptHandleResult.False;
    }

    private void ColumnChosen(CallInfo info, int col0)
    {
        Log.Info($"[DungeonSolitaire] ColumnChosen col={col0}"); // DEBUG (round 2)
        if (_session is not { IsAlive: true } || info.ObjectSelf is not NwCreature ally) return;
        _session.SubmitAttack(ally, col0);
    }

    [ScriptHandler("ds_atkaoe")]
    public ScriptHandleResult UnleashAvailable(CallInfo info)
    {
        if (_session is not { IsAlive: true }) return ScriptHandleResult.False;
        if (info.ObjectSelf is not NwCreature ally) return ScriptHandleResult.False;
        if (!_session.IsAwaitingAlly) return ScriptHandleResult.False;
        Card? card = _session.CardForCreature(ally);
        return card != null && DsSession.IsInsteadOfAttack(card) ? ScriptHandleResult.True : ScriptHandleResult.False;
    }

    [ScriptHandler("ds_atkaoedo")]
    public void UnleashChosen(CallInfo info)
    {
        if (_session is not { IsAlive: true } || info.ObjectSelf is not NwCreature ally) return;
        _session.SubmitUnleash(ally);
    }

    // ── Secondary-choice popup (ds_choice) ───────────────────────────────────────
    // Spoken by the session's invisible narrator and started privately for the active
    // player, so these gate on the live session rather than the ally-click _speaker.
    // Condition scripts ds_chc0..9 enable option slots; ds_chcnext enables paging.
    // Action scripts ds_chs0..9 submit a choice; ds_chnext pages; ds_chend re-pops on abort.
    [ScriptHandler("ds_chc0")] public ScriptHandleResult Chc0(CallInfo i) => SlotCond(0);
    [ScriptHandler("ds_chc1")] public ScriptHandleResult Chc1(CallInfo i) => SlotCond(1);
    [ScriptHandler("ds_chc2")] public ScriptHandleResult Chc2(CallInfo i) => SlotCond(2);
    [ScriptHandler("ds_chc3")] public ScriptHandleResult Chc3(CallInfo i) => SlotCond(3);
    [ScriptHandler("ds_chc4")] public ScriptHandleResult Chc4(CallInfo i) => SlotCond(4);
    [ScriptHandler("ds_chc5")] public ScriptHandleResult Chc5(CallInfo i) => SlotCond(5);
    [ScriptHandler("ds_chc6")] public ScriptHandleResult Chc6(CallInfo i) => SlotCond(6);
    [ScriptHandler("ds_chc7")] public ScriptHandleResult Chc7(CallInfo i) => SlotCond(7);
    [ScriptHandler("ds_chc8")] public ScriptHandleResult Chc8(CallInfo i) => SlotCond(8);
    [ScriptHandler("ds_chc9")] public ScriptHandleResult Chc9(CallInfo i) => SlotCond(9);

    [ScriptHandler("ds_chcnext")]
    public ScriptHandleResult ChcNext(CallInfo i)
        => _session is { IsAlive: true } && _session.ChoiceHasNextPage()
            ? ScriptHandleResult.True : ScriptHandleResult.False;

    [ScriptHandler("ds_chs0")] public void Chs0(CallInfo i) => _session?.SubmitChoiceSlot(0);
    [ScriptHandler("ds_chs1")] public void Chs1(CallInfo i) => _session?.SubmitChoiceSlot(1);
    [ScriptHandler("ds_chs2")] public void Chs2(CallInfo i) => _session?.SubmitChoiceSlot(2);
    [ScriptHandler("ds_chs3")] public void Chs3(CallInfo i) => _session?.SubmitChoiceSlot(3);
    [ScriptHandler("ds_chs4")] public void Chs4(CallInfo i) => _session?.SubmitChoiceSlot(4);
    [ScriptHandler("ds_chs5")] public void Chs5(CallInfo i) => _session?.SubmitChoiceSlot(5);
    [ScriptHandler("ds_chs6")] public void Chs6(CallInfo i) => _session?.SubmitChoiceSlot(6);
    [ScriptHandler("ds_chs7")] public void Chs7(CallInfo i) => _session?.SubmitChoiceSlot(7);
    [ScriptHandler("ds_chs8")] public void Chs8(CallInfo i) => _session?.SubmitChoiceSlot(8);
    [ScriptHandler("ds_chs9")] public void Chs9(CallInfo i) => _session?.SubmitChoiceSlot(9);

    [ScriptHandler("ds_chnext")] public void ChNext(CallInfo i) => _session?.NextChoicePage();
    [ScriptHandler("ds_chend")]  public void ChEnd(CallInfo i)  => _session?.OnChoiceConversationEnded();

    private ScriptHandleResult SlotCond(int slot)
        => _session is { IsAlive: true } && _session.ChoiceSlotActive(slot)
            ? ScriptHandleResult.True : ScriptHandleResult.False;
}
