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
}
