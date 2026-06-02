using System.Text;
using System.Text.Json;
using Anvil.API;
using Anvil.Services;
using NLog;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Persists Dungeon Solitaire results and renders the leaderboard onto the
/// DS_HighScore gravestone's description.
///
/// Persistence is a small JSON file under the server's plugin-data directory
/// (<see cref="HomeStorage.PluginData"/>) — a self-contained, dependency-free
/// store that survives restarts. The same text is also exposed for the gravestone's
/// conversation fallback. All disk access is guarded so a storage failure never
/// breaks a game in progress.
/// </summary>
[ServiceBinding(typeof(HighScoreStore))]
internal sealed class HighScoreStore
{
    private static readonly Logger Log = LogManager.GetCurrentClassLogger();

    public sealed record Entry(string Name, int Score, int Turns, bool Won, DateTime DateUtc);

    private readonly string _path;
    private List<Entry> _entries;

    public HighScoreStore()
    {
        string dir = Path.Combine(HomeStorage.PluginData, "DungeonSolitaire");
        _path = Path.Combine(dir, "highscores.json");
        _entries = Load();
        // Reflect persisted scores onto the in-world sign as soon as the module is ready.
        UpdateSign();
    }

    public void Record(string name, int score, int turns, bool won)
    {
        _entries.Add(new Entry(string.IsNullOrWhiteSpace(name) ? "Unknown" : name, score, turns, won, DateTime.UtcNow));
        _entries = _entries
            .OrderByDescending(e => e.Won)
            .ThenByDescending(e => e.Score)
            .ThenBy(e => e.Turns)
            .Take(DsConfig.HighScoreCount)
            .ToList();
        Save();
        UpdateSign();
    }

    /// <summary>Human-readable leaderboard for the sign description / conversation fallback.</summary>
    public string RenderTable()
    {
        if (_entries.Count == 0)
            return "Dungeon Solitaire — High Scores\n\nNo champions yet. Pull the lever and be the first!";

        var sb = new StringBuilder("Dungeon Solitaire — High Scores\n");
        int rank = 1;
        foreach (Entry e in _entries)
        {
            string outcome = e.Won ? "WON" : "lost";
            sb.Append($"\n{rank,2}. {e.Name}  —  {e.Score} ({outcome}, {e.Turns} turns)");
            rank++;
        }
        return sb.ToString();
    }

    public void UpdateSign()
    {
        try
        {
            foreach (NwPlaceable sign in NwObject.FindObjectsWithTag<NwPlaceable>(DsConfig.HighScoreTag))
                sign.Description = RenderTable();
        }
        catch (Exception ex)
        {
            Log.Warn(ex, "[DungeonSolitaire] could not update high-score sign");
        }
    }

    private List<Entry> Load()
    {
        try
        {
            if (File.Exists(_path))
                return JsonSerializer.Deserialize<List<Entry>>(File.ReadAllText(_path)) ?? new();
        }
        catch (Exception ex)
        {
            Log.Warn(ex, "[DungeonSolitaire] could not read high scores; starting fresh");
        }
        return new();
    }

    private void Save()
    {
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(_path)!);
            File.WriteAllText(_path, JsonSerializer.Serialize(_entries, new JsonSerializerOptions { WriteIndented = true }));
        }
        catch (Exception ex)
        {
            Log.Error(ex, "[DungeonSolitaire] could not write high scores");
        }
    }
}
