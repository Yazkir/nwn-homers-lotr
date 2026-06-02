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

    // Conversation context, set when a PC starts talking to an ally NPC.
    private NwPlayer? _speaker;

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
        _speaker = evt.PlayerSpeaker;
        if (_session is { IsAlive: true } && _speaker != null && _speaker != _session.ActivePlayer)
            _speaker.SendServerMessage("You are only watching this game of Dungeon Solitaire.", ColorConstants.Orange);
    }

    private bool ActiveSpeaker => _session is { IsAlive: true } && _speaker != null && _speaker == _session.ActivePlayer;

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
        if (!ActiveSpeaker || _session == null) return ScriptHandleResult.False;
        if (info.ObjectSelf is not NwCreature ally) return ScriptHandleResult.False;
        if (!_session.IsAwaitingAlly) return ScriptHandleResult.False;
        Card? card = _session.CardForCreature(ally);
        if (card == null || DsSession.IsInsteadOfAttack(card)) return ScriptHandleResult.False;
        return _session.ColumnHasEnemies(col0) ? ScriptHandleResult.True : ScriptHandleResult.False;
    }

    private void ColumnChosen(CallInfo info, int col0)
    {
        if (!ActiveSpeaker || _session == null || info.ObjectSelf is not NwCreature ally) return;
        _session.SubmitAttack(ally, col0);
    }

    [ScriptHandler("ds_atkaoe")]
    public ScriptHandleResult UnleashAvailable(CallInfo info)
    {
        if (!ActiveSpeaker || _session == null) return ScriptHandleResult.False;
        if (info.ObjectSelf is not NwCreature ally) return ScriptHandleResult.False;
        if (!_session.IsAwaitingAlly) return ScriptHandleResult.False;
        Card? card = _session.CardForCreature(ally);
        return card != null && DsSession.IsInsteadOfAttack(card) ? ScriptHandleResult.True : ScriptHandleResult.False;
    }

    [ScriptHandler("ds_atkaoedo")]
    public void UnleashChosen(CallInfo info)
    {
        if (!ActiveSpeaker || _session == null || info.ObjectSelf is not NwCreature ally) return;
        _session.SubmitUnleash(ally);
    }
}
