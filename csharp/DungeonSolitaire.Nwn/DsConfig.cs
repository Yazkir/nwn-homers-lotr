namespace DungeonSolitaire.Nwn;

/// <summary>
/// Static configuration for the Dungeon Solitaire board: the prepped area, the
/// waypoint/placeable tags placed in it, and the timing values ported from the
/// Godot front-end (Dungeon-Solitaire.Godot). Nothing here touches Anvil so the
/// engine/board code can share it freely.
/// </summary>
internal static class DsConfig
{
    /// <summary>ResRef of the prepped "Dungeon Solitaire" area (area017.are.json).</summary>
    public const string AreaResRef = "area017";

    // ── Placeable / waypoint tags (see unpacked/area017.git.json) ────────────
    public const string LeverTag       = "DS_NewGame";
    public const string HighScoreTag   = "DS_HighScore";
    public const string HowToPlayTag   = "DS_HowToPlay";
    public const string CreditsTag     = "DS_credits";
    public const string HandRallyTag   = "DS_Hand";        // where ally NPCs line up
    public const string HandSpawnTag   = "DS_Hand_SPAWN";  // where ally NPCs first appear
    public const string GraveyardTag   = "DS_Graveyard";
    public const string ExileTag       = "DS_EXILE";

    /// <summary>5 columns × 4 rows of enemy slots: DS_C{1..5}_R{1..4}. Row 1 is the front.</summary>
    public const int ColumnCount = 5;
    public const int RowCount = 4;
    public static string ColumnRowTag(int col0, int row0) => $"DS_C{col0 + 1}_R{row0 + 1}";

    /// <summary>Conversation resref opened on an ally NPC to pick a target column.</summary>
    public const string AttackDialog = "ds_attack";

    /// <summary>Conversation resref popped for secondary mid-turn choices (discard, pick target, effect order, …).</summary>
    public const string ChoiceDialog = "ds_choice";

    // ── Choice-popup custom tokens (set via NWScript.SetCustomToken before each popup) ──
    /// <summary>Custom token holding the choice prompt text (the entry node shows &lt;CUSTOM5400&gt;).</summary>
    public const int ChoicePromptToken = 5400;
    /// <summary>First option slot token; slot i uses ChoiceOptionTokenBase + i (5401..5410).</summary>
    public const int ChoiceOptionTokenBase = 5401;
    /// <summary>Token for the "next page" reply label (&lt;CUSTOM5411&gt;).</summary>
    public const int ChoiceNextPageToken = 5411;
    /// <summary>Option slots shown per page in the choice menu.</summary>
    public const int ChoicePageSize = 10;

    /// <summary>Seconds to wait before re-opening a choice popup the player closed without answering.</summary>
    public const double ChoiceReopenDelay = 3.0;

    // ── Timing (seconds) — ported from the Godot front-end ───────────────────
    public const double LungeSeconds          = 0.30; // ally moves onto the target column
    public const double FlipSeconds           = 0.20; // statue -> creature reveal beat
    public const double MoveSeconds           = 0.25; // generic card move
    public const double EffectActivatedPause  = 0.40; // EffectActivated -> ack
    public const double EffectResolvedPause   = 0.80; // EffectResolved  -> ack
    public const double TurnEndHold           = 1.00; // pause on turn-end ack
    public const double GameOverHold          = 4.00; // keep the board up after win/loss
    public const double ReturnSeconds         = 0.25; // ally walks back to the hand line

    // ── Active-player lifecycle ──────────────────────────────────────────────
    /// <summary>Grace period after the active player leaves the area / logs out before the board clears.</summary>
    public const double AbandonSeconds = 30.0;
    public const double WatchTickSeconds = 3.0;

    // ── Hand fan-out ─────────────────────────────────────────────────────────
    /// <summary>Spacing (metres) between ally NPCs lined up around the DS_Hand waypoint.</summary>
    public const float HandSpacing = 2.0f;

    public const int HighScoreCount = 10;

    // ── Narration ────────────────────────────────────────────────────────────
    /// <summary>
    /// Engine <see cref="LogLevel"/>s the narrator does NOT speak. Console parity
    /// would be just <c>{ Debug }</c>; the extra two trim the low-priority chatter
    /// so the talk window stays readable.
    /// </summary>
    public static readonly HashSet<LogLevel> SuppressedLogLevels =
        new() { LogLevel.Debug, LogLevel.Subtle, LogLevel.ExtraInfo };
}
