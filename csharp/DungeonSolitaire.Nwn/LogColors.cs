using Anvil.API;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Maps the engine's <see cref="LogLevel"/> to an NWN talk colour, mirroring the
/// console front-end's per-level palette (DungeonSolitaire.Console/Program.cs).
/// Used by <see cref="DsSession"/> to colour the narrator's spoken lines via
/// <c>string.ColorString(Color)</c>.
/// </summary>
internal static class LogColors
{
    private static readonly Color Cyan   = new(0, 255, 255, 255);
    private static readonly Color Green  = new(0, 200, 0, 255);
    private static readonly Color Orange = new(255, 140, 0, 255);

    public static Color ForLevel(LogLevel level) => level switch
    {
        LogLevel.Info         => new Color(255, 255, 255, 255), // White
        LogLevel.ExtraInfo    => new Color(0, 128, 0, 255),     // DarkGreen
        LogLevel.Subtle       => new Color(128, 128, 128, 255), // DarkGray
        LogLevel.InputRequest => new Color(255, 255, 0, 255),   // Yellow
        LogLevel.Warning      => new Color(255, 0, 0, 255),     // Red
        LogLevel.Error        => new Color(128, 0, 0, 255),     // DarkRed
        LogLevel.Effect       => new Color(128, 128, 0, 255),   // DarkYellow
        _                     => new Color(255, 255, 255, 255),
    };

    /// <summary>
    /// Colour for a single log line: content accents override the per-level colour so the
    /// unified combat log reads at a glance — phase banners (a line wrapped in '=') in cyan,
    /// rewards in green, damage/defeat in orange. Everything else falls back to the level.
    /// </summary>
    public static Color ForLine(LogLevel level, string line)
    {
        string t = line.Trim();
        if (t.StartsWith("=") && t.EndsWith("=")) return Cyan;     // === Phase banners ===
        string lower = t.ToLowerInvariant();
        if (lower.Contains("reward")) return Green;
        if (lower.Contains("defeated") || lower.Contains("damage")) return Orange;
        return ForLevel(level);
    }
}
