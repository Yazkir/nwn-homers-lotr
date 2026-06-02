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
}
