using Anvil.API;
using NLog;
using NwEffect = Anvil.API.Effect;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// One live game of Dungeon Solitaire owned by a single active player.
///
/// The blocking <see cref="GameEngine"/> runs on a background thread; its
/// GameEventBus events are marshalled onto the main thread via the
/// <see cref="MainThreadDispatcher"/>, where they drive the board, VFX, and the
/// effect-pacing / input handshake. This mirrors the Godot front-end's
/// worker-thread + CallDeferred model.
/// </summary>
internal sealed class DsSession : IGameEventListener
{
    private static readonly Logger Log = LogManager.GetCurrentClassLogger();

    public NwPlayer ActivePlayer { get; }
    public string ActivePlayerName { get; }
    public BoardView Board { get; }

    private readonly MainThreadDispatcher _dispatcher;
    private readonly HighScoreStore _scores;
    private readonly System.Action _onEnded;

    private GameEngine _engine = null!;
    private Thread? _thread;
    private volatile bool _alive;
    private int? _pendingColumn;   // column stashed by the attack conversation, consumed on the next SelectColumn

    public DsSession(NwPlayer activePlayer, BoardView board, MainThreadDispatcher dispatcher,
                     HighScoreStore scores, System.Action onEnded)
    {
        ActivePlayer = activePlayer;
        ActivePlayerName = activePlayer.PlayerName;
        Board = board;
        _dispatcher = dispatcher;
        _scores = scores;
        _onEnded = onEnded;
    }

    public bool IsAlive => _alive;

    // ── Lifecycle ──────────────────────────────────────────────────────────────
    public void Start()
    {
        _engine = new GameEngine { EffectPacingEnabled = true };
        GameEventBus.Subscribe(this);
        Board.OnAllySpawned += OnAllyCreatureSpawned;
        Board.Sync(_engine);
        Announce($"{ActivePlayerName} sits down to a game of Dungeon Solitaire.");
        MessageActive("Click one of your allies to send it into battle.");

        _alive = true;
        _thread = new Thread(RunLoop) { IsBackground = true, Name = "DungeonSolitaireEngine" };
        _thread.Start();
    }

    private void RunLoop()
    {
        try
        {
            while (_alive && !_engine.IsWin && !_engine.IsLoss)
                _engine.RunTurn();
        }
        catch (Exception ex)
        {
            Log.Error(ex, "[DungeonSolitaire] engine loop crashed");
        }
    }

    public void Teardown()
    {
        if (!_alive && _thread == null) return;
        _alive = false;
        GameEventBus.Unsubscribe(this);
        Board.OnAllySpawned -= OnAllyCreatureSpawned;
        // Unblock the engine thread if it is parked on input or effect ack so it can exit.
        try { _engine?.SubmitInput(GameCommand.Confirm); } catch { /* not waiting */ }
        try { _engine?.AcknowledgeEffect(); } catch { /* not waiting */ }
        _thread = null;
        Board.Clear();
    }

    // ── Attack flow (called on the main thread from DsManager's script handlers) ──
    public bool IsAwaitingAlly => _engine?.PendingInput?.Type == InputType.SelectAlly;

    public Card? CardForCreature(NwCreature creature) => Board.ActorFor(creature)?.Card;

    public bool ColumnHasEnemies(int col)
        => col >= 0 && col < _engine.EnemyColumns.Count && _engine.EnemyColumns[col].Count > 0;

    public static bool IsInsteadOfAttack(Card card)
        => card.attackEffect?.triggerWhen == TriggerWhen.InsteadOfAttack;

    public void SubmitAttack(NwCreature ally, int col)
    {
        if (!IsAwaitingAlly) return;
        Card? card = CardForCreature(ally);
        if (card == null) return;
        int idx = _engine.Hand.cards.IndexOf(card);
        if (idx < 0) return;

        _pendingColumn = col;                       // consumed by the upcoming SelectColumn request
        CardActor? actor = Board.ActorFor(ally);
        _dispatcher.Enqueue(async () =>
        {
            if (actor != null) await Board.AnimateAttack(actor, col, _engine);
            _engine.SubmitInput(new GameCommand(idx));
        });
    }

    public void SubmitUnleash(NwCreature ally)
    {
        if (!IsAwaitingAlly) return;
        Card? card = CardForCreature(ally);
        if (card == null) return;
        int idx = _engine.Hand.cards.IndexOf(card);
        if (idx < 0) return;

        _pendingColumn = null;                      // InsteadOfAttack: engine skips column selection
        _dispatcher.Enqueue(() => _engine.SubmitInput(new GameCommand(idx)));
    }

    // ── Engine events (raised on the background thread) ──────────────────────────
    public void OnGameEvent(GameEvent e)
    {
        switch (e.EventType)
        {
            case GameEventType.InputRequested:
                HandleInputRequest(e.Request);
                break;

            case GameEventType.EffectActivated:
            {
                Card? src = e.Source;
                string? fx = e.Effect?.name;
                if (e.PacingRequired)
                    _dispatcher.Enqueue(async () =>
                    {
                        PlayEffectVfx(src, fx);
                        await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.EffectActivatedPause));
                        _engine.AcknowledgeEffect();
                    });
                else
                    _dispatcher.Enqueue(() => PlayEffectVfx(src, fx));
                break;
            }

            case GameEventType.EffectResolved:
                if (e.PacingRequired)
                    _dispatcher.Enqueue(async () =>
                    {
                        await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.EffectResolvedPause));
                        _engine.AcknowledgeEffect();
                    });
                break;

            case GameEventType.CardDamaged:
            {
                Card? tgt = e.Targets.FirstOrDefault();
                _dispatcher.Enqueue(() =>
                {
                    if (tgt != null && Board.Actors.TryGetValue(tgt, out CardActor? a) && a.Obj is { IsValid: true })
                        a.Obj.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.MeleeImpact));
                });
                break;
            }

            case GameEventType.CardRevealed:
            case GameEventType.CardZoneChanged:
            case GameEventType.CardRepositioned:
            case GameEventType.CardHealed:
                _dispatcher.Enqueue(() => Board.Sync(_engine));
                break;

            case GameEventType.GameWon:
                _dispatcher.Enqueue(() =>
                {
                    Board.Sync(_engine);
                    _scores.Record(ActivePlayerName, _engine.Score, _engine.turn, true);
                    Announce($"Victory! {ActivePlayerName} cleared the dungeon — score {_engine.Score}.");
                });
                break;

            case GameEventType.GameLost:
                _dispatcher.Enqueue(() =>
                {
                    Board.Sync(_engine);
                    _scores.Record(ActivePlayerName, _engine.Score, _engine.turn, false);
                    Announce($"Defeat. {ActivePlayerName} fell to the dungeon — score {_engine.Score}.");
                });
                break;
        }
    }

    private void HandleInputRequest(InputRequest req)
    {
        switch (req.Type)
        {
            case InputType.SelectAlly:
                // Resolved by the player clicking an ally NPC (see DsManager conversation handlers).
                _dispatcher.Enqueue(() => MessageActive("Click an ally to send it into battle."));
                break;

            case InputType.SelectColumn:
                _dispatcher.Enqueue(() =>
                {
                    int col = _pendingColumn ?? 0;
                    _pendingColumn = null;
                    if (col < 0 || col >= _engine.EnemyColumns.Count) col = 0;
                    _engine.SubmitInput(new GameCommand(col));
                });
                break;

            case InputType.AcknowledgeTurnEnd:
                _dispatcher.Enqueue(async () =>
                {
                    Board.Sync(_engine);
                    await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.TurnEndHold));
                    _engine.SubmitInput(GameCommand.Confirm);
                });
                break;

            default:
                // Secondary effect-driven choices (discard / pick target / effect order) auto-resolve
                // with the first option so the vertical slice plays through; see plan's known limitations.
                _dispatcher.Enqueue(() => _engine.SubmitInput(new GameCommand(0)));
                break;
        }
    }

    private void PlayEffectVfx(Card? source, string? effectName)
    {
        if (source != null && Board.Actors.TryGetValue(source, out CardActor? a) && a.Obj is { IsValid: true })
            a.Obj.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.ForEffect(effectName)));
    }

    private void OnAllyCreatureSpawned(NwCreature ally) => AllyConversationHook?.Invoke(ally);

    /// <summary>DsManager wires this to attach its OnConversation handler to each new ally NPC.</summary>
    public System.Action<NwCreature>? AllyConversationHook { get; set; }

    // ── Messaging ───────────────────────────────────────────────────────────────
    private void MessageActive(string msg)
    {
        if (ActivePlayer.IsValid) ActivePlayer.SendServerMessage(msg, ColorConstants.Lime);
    }

    private void Announce(string msg)
    {
        foreach (NwPlayer p in NwModule.Instance.Players)
            if (p.IsValid && p.ControlledCreature?.Area == Board.Area)
                p.SendServerMessage(msg, ColorConstants.Yellow);
    }
}
