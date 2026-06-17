using Anvil.API;
using NLog;
using NWN.Core;
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
    private bool _recorded;        // guards one-time high-score recording at game over
    private int _choicePage;       // current page of the secondary-choice popup menu
    private NwPlaceable? _narrator; // floor-paint placeable (DS_SpawnIn) used as the narrator

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

        // Locate the narrator placeable and relay the engine's GameLogger commentary
        // through it as spoken talk. Start() runs on the main thread, so this is safe.
        GetNarrator();
        GameLogger.Log = OnEngineLog;

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
        GameLogger.Log = (_, _) => { };   // stop relaying engine logs before the narrator is destroyed
        GameEventBus.Unsubscribe(this);
        Board.OnAllySpawned -= OnAllyCreatureSpawned;
        // Unblock the engine thread if it is parked on input or effect ack so it can exit.
        try { _engine?.SubmitInput(GameCommand.Confirm); } catch { /* not waiting */ }
        try { _engine?.AcknowledgeEffect(); } catch { /* not waiting */ }
        _thread = null;
        _narrator = null; // DS_SpawnIn is a permanent area object — not destroyed
        Board.Clear();
    }

    // ── Attack flow (called on the main thread from DsManager's script handlers) ──
    public bool IsAwaitingAlly => _engine?.PendingInput?.Type == InputType.SelectAlly;

    public Card? CardForCreature(NwCreature creature) => Board.ActorFor(creature)?.Card;

    public bool ColumnHasEnemies(int col)
        => col >= 0 && col < _engine.EnemyColumns.Count && _engine.EnemyColumns[col].Count > 0;

    /// <summary>The front (first still-alive) enemy of a column — the card an attack on it strikes.</summary>
    public Card? ColumnFront(int col)
        => col >= 0 && col < _engine.EnemyColumns.Count
            ? _engine.EnemyColumns[col].FirstOrDefault(c => c.currentHealth > 0)
            : null;

    /// <summary>
    /// Seed the ds_attack reply tokens (ColumnNameTokenBase + col0) with each column's
    /// front-enemy name, so the picker reads "Attack &lt;name&gt; (Nth column)". Called on the
    /// main thread from DsManager just before the conversation opens. Empty columns get a
    /// blank token; their reply is hidden anyway by the ds_atkc* condition handlers.
    /// </summary>
    public void RefreshAttackTokens()
    {
        for (int col = 0; col < DsConfig.ColumnCount; col++)
            NWScript.SetCustomToken(DsConfig.ColumnNameTokenBase + col, ColumnFront(col)?.name ?? "");
    }

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
                        // Safe to read engine state: it is blocked awaiting this effect's ack.
                        Board.Sync(_engine);
                        PlayEffectVfx(src, fx);
                        await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.EffectActivatedPause));
                        _engine.AcknowledgeEffect();
                    });
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

            // CardRevealed / CardZoneChanged / CardRepositioned / CardHealed fire while the
            // engine thread is still running, so we do NOT read engine state here. The board
            // is reconciled at the next safe point (paced effect beat, turn-end, game-over),
            // where the engine is provably blocked. Win/loss is likewise finalised in the
            // turn-end handler, the first point after game over where the engine is parked.
        }
    }

    private void HandleInputRequest(InputRequest req)
    {
        switch (req.Type)
        {
            case InputType.SelectAlly:
                // Engine is blocked here — safe to reconcile the board to the new turn's state.
                // Resolved by the player clicking an ally NPC (see DsManager conversation handlers).
                _dispatcher.Enqueue(() =>
                {
                    Board.Sync(_engine);
                    MessageActive("Click an ally to send it into battle.");
                });
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
                    Board.Sync(_engine);                       // engine blocked here — safe snapshot
                    bool over = _engine.IsWin || _engine.IsLoss;
                    if (over && !_recorded)
                    {
                        _recorded = true;
                        _scores.Record(ActivePlayerName, _engine.Score, _engine.turn, _engine.IsWin);
                        Announce(_engine.IsWin
                            ? $"Victory! {ActivePlayerName} cleared the dungeon — score {_engine.Score}."
                            : $"Defeat. {ActivePlayerName} fell to the dungeon — score {_engine.Score}.");
                    }
                    await NwTask.Delay(TimeSpan.FromSeconds(over ? DsConfig.GameOverHold : DsConfig.TurnEndHold));
                    _engine.SubmitInput(GameCommand.Confirm);
                });
                break;

            default:
                // Secondary effect-driven choices (discard / pick target / effect order / yes-no):
                // pop a conversation so the player decides, rather than auto-picking option 0.
                // Engine is blocked here, so the request's option lists are safe to read.
                _dispatcher.Enqueue(() => { _choicePage = 0; PromptCurrentChoice(); });
                break;
        }
    }

    // ── Secondary-choice popup (called on the main thread) ───────────────────────
    private static bool IsSecondaryChoice(InputRequest? req) => req != null && req.Type is
        InputType.SelectCardFromHand or InputType.SelectCardFromGraveyard or
        InputType.SelectEnemy or InputType.SelectEffect or InputType.SelectChoice;

    private static int OptionCount(InputRequest req) => req.Type switch
    {
        InputType.SelectEffect => req.EffectOptions?.Count ?? 0,
        InputType.SelectChoice => req.StringOptions?.Count ?? 0,
        _                      => req.CardOptions?.Count ?? 0,
    };

    private static List<string> OptionLabels(InputRequest req)
    {
        var labels = new List<string>();
        switch (req.Type)
        {
            case InputType.SelectEffect:
                foreach (CardEffect ce in req.EffectOptions ?? new List<CardEffect>())
                    labels.Add($"{ce.effect.name}  — {ce.card.name}");
                break;
            case InputType.SelectChoice:
                labels.AddRange(req.StringOptions ?? new List<string>());
                break;
            default:
                bool asEnemy = req.ShowCardsAsEnemies || req.Type == InputType.SelectEnemy;
                foreach (Card c in req.CardOptions ?? new List<Card>())
                    labels.Add(CardCreatureMap.ChoiceLabel(c, asEnemy));
                break;
        }
        return labels;
    }

    /// <summary>Open (or re-open) the choice popup for whatever secondary input the engine is awaiting.</summary>
    private void PromptCurrentChoice()
    {
        InputRequest? req = _engine?.PendingInput;
        if (!IsSecondaryChoice(req) || !ActivePlayer.IsValid
            || ActivePlayer.ControlledCreature is not { IsValid: true } pc) return;

        int count = OptionCount(req!);
        int pages = Math.Max(1, (count + DsConfig.ChoicePageSize - 1) / DsConfig.ChoicePageSize);
        if (_choicePage >= pages) _choicePage = 0;

        RefreshChoiceTokens(req!);

        NwGameObject? speaker = GetNarrator();
        if (speaker == null) { Log.Warn("[DungeonSolitaire] narrator (DS_SpawnIn) not found — choice menu unavailable"); return; }
        ActivePlayer.ActionStartConversation(speaker, DsConfig.ChoiceDialog, true, false);
    }

    /// <summary>Set the prompt / per-slot / next-page custom tokens for the current page.</summary>
    private void RefreshChoiceTokens(InputRequest req)
    {
        List<string> labels = OptionLabels(req);
        int start = _choicePage * DsConfig.ChoicePageSize;
        NWScript.SetCustomToken(DsConfig.ChoicePromptToken,
            string.IsNullOrWhiteSpace(req.Context) ? "Make a choice:" : req.Context);
        for (int i = 0; i < DsConfig.ChoicePageSize; i++)
        {
            int abs = start + i;
            string text = abs < labels.Count ? $"{abs + 1}. {labels[abs]}" : "";
            NWScript.SetCustomToken(DsConfig.ChoiceOptionTokenBase + i, text);
        }
        bool hasNext = labels.Count > (_choicePage + 1) * DsConfig.ChoicePageSize;
        NWScript.SetCustomToken(DsConfig.ChoiceNextPageToken, hasNext ? "(more options…)" : "");
    }

    /// <summary>
    /// Returns the permanent narrator placeable (DS_SpawnIn floor paint in area017),
    /// caching it after the first lookup. Sets its name to "The Dungeon" on first find.
    /// </summary>
    private NwPlaceable? GetNarrator()
    {
        if (_narrator is { IsValid: true }) return _narrator;
        _narrator = NwObject.FindObjectsWithTag<NwPlaceable>("DS_SpawnIn").FirstOrDefault();
        if (_narrator != null) _narrator.Name = "The Dungeon";
        return _narrator;
    }

    // ── Choice handshake (called on the main thread from DsManager's ds_ch* handlers) ──
    /// <summary>True while the engine is blocked awaiting a secondary choice.</summary>
    public bool IsAwaitingChoice => IsSecondaryChoice(_engine?.PendingInput);

    /// <summary>Is option <paramref name="slot"/> on the current page within range?</summary>
    public bool ChoiceSlotActive(int slot)
    {
        InputRequest? req = _engine?.PendingInput;
        return IsSecondaryChoice(req) && _choicePage * DsConfig.ChoicePageSize + slot < OptionCount(req!);
    }

    /// <summary>Are there more options beyond the current page?</summary>
    public bool ChoiceHasNextPage()
    {
        InputRequest? req = _engine?.PendingInput;
        return IsSecondaryChoice(req) && OptionCount(req!) > (_choicePage + 1) * DsConfig.ChoicePageSize;
    }

    /// <summary>Resolve the engine input with the option in the given on-screen slot.</summary>
    public void SubmitChoiceSlot(int slot)
    {
        InputRequest? req = _engine?.PendingInput;
        if (!IsSecondaryChoice(req)) return;
        int abs = _choicePage * DsConfig.ChoicePageSize + slot;
        if (abs < 0 || abs >= OptionCount(req!)) return;
        _choicePage = 0;
        _engine!.SubmitInput(new GameCommand(abs));
    }

    /// <summary>Advance the menu to the next page (the "more options" reply loops back to the entry).</summary>
    public void NextChoicePage()
    {
        InputRequest? req = _engine?.PendingInput;
        if (!IsSecondaryChoice(req)) return;
        _choicePage++;
        RefreshChoiceTokens(req!);   // entry redisplays after this handler returns; refresh now so it reads the new page
    }

    /// <summary>
    /// Fired when the choice conversation closes (normal end or abort). If the engine is
    /// still blocked on the very same request a few seconds later, the player closed it
    /// without answering — re-open it. A real selection advances the engine (PendingInput
    /// becomes a different request), so this is a no-op there.
    /// </summary>
    public void OnChoiceConversationEnded()
    {
        InputRequest? req = _engine?.PendingInput;
        if (!IsSecondaryChoice(req)) return;
        _dispatcher.Enqueue(async () =>
        {
            await NwTask.Delay(TimeSpan.FromSeconds(DsConfig.ChoiceReopenDelay));
            if (_alive && ReferenceEquals(_engine?.PendingInput, req))
            {
                _choicePage = 0;
                PromptCurrentChoice();
            }
        });
    }

    private void PlayEffectVfx(Card? source, string? effectName)
    {
        if (source != null && Board.Actors.TryGetValue(source, out CardActor? a) && a.Obj is { IsValid: true })
            a.Obj.ApplyEffect(EffectDuration.Instant, NwEffect.VisualEffect(Vfx.ForEffect(effectName)));
    }

    private void OnAllyCreatureSpawned(NwCreature ally) => AllyConversationHook?.Invoke(ally);

    /// <summary>DsManager wires this to attach its OnConversation handler to each new ally NPC.</summary>
    public System.Action<NwCreature>? AllyConversationHook { get; set; }

    // ── Engine log relay (GameLogger.Log fires on the engine background thread) ──
    /// <summary>
    /// Relay an engine log line to the narrator as spoken talk. Marshals onto the
    /// main thread via the dispatcher (in emission order, so narration interleaves
    /// correctly with the paced VFX/Sync beats). Suppressed levels are dropped;
    /// banners that span multiple lines are spoken one line at a time.
    /// </summary>
    private void OnEngineLog(LogLevel level, string message)
    {
        if (DsConfig.SuppressedLogLevels.Contains(level)) return;
        Color color = LogColors.ForLevel(level);
        foreach (string raw in message.Split('\n'))
        {
            string line = raw.Trim();
            if (line.Length == 0) continue;
            string spoken = line.ColorString(color);
            _dispatcher.Enqueue(() => Narrate(spoken));
        }
    }

    private void Narrate(string text)
    {
        if (_alive && _narrator is { IsValid: true } n) n.SpeakString(text);
    }

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
