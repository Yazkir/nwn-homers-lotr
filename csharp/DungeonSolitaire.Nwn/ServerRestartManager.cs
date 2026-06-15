using Anvil.API;
using Anvil.Services;
using NWN.Core;
using NLog;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Drives the daily scheduled restart: broadcasts countdown warnings to every
/// online player, then at T-0 exports all characters and shuts the server down
/// cleanly. The host (a root systemd timer) reboots the machine a few minutes
/// later and the server auto-starts on boot.
///
/// Schedule comes from the <c>ANVIL_RESTART_DAILY</c> environment variable
/// (HH:mm, server-local time; forwarded from server.env). Set it empty to
/// disable. A control file <c>&lt;PluginData&gt;/restart-now</c> triggers the
/// shutdown sequence immediately, for testing without waiting for the clock.
/// </summary>
[ServiceBinding(typeof(ServerRestartManager))]
internal sealed class ServerRestartManager
{
    private static readonly Logger Log = LogManager.GetCurrentClassLogger();

    // Minutes-remaining marks at which a warning is broadcast (plus a final at 0).
    private static readonly int[] WarnMarks = { 60, 30, 15, 10, 5, 1 };
    private static readonly TimeSpan Tick = TimeSpan.FromSeconds(15);
    private const string DownDuration = "about 8 minutes";

    private readonly TimeSpan? _target;     // local time-of-day, or null when disabled
    private readonly string _controlFile;

    public ServerRestartManager()
    {
        _controlFile = Path.Combine(HomeStorage.PluginData, "restart-now");
        _target = ParseTarget(Environment.GetEnvironmentVariable("ANVIL_RESTART_DAILY"));
        if (_target == null)
        {
            Log.Info("[ServerRestart] ANVIL_RESTART_DAILY unset/invalid — scheduled restart disabled "
                     + "(control file still honoured: " + _controlFile + ")");
        }
        else
        {
            Log.Info($"[ServerRestart] daily restart armed for {_target:hh\\:mm} server-local time.");
        }
        _ = RunLoop();
    }

    private static TimeSpan? ParseTarget(string? hhmm)
    {
        if (string.IsNullOrWhiteSpace(hhmm)) return null;
        return TimeSpan.TryParseExact(hhmm.Trim(), new[] { "hh\\:mm", "h\\:mm" }, null, out TimeSpan t)
            ? t : (TimeSpan?)null;
    }

    private async Task RunLoop()
    {
        await NwTask.SwitchToMainThread();

        DateTime? nextRestart = _target == null ? null : NextOccurrence(_target.Value);
        var announced = new HashSet<int>();
        double prevRemaining = double.MaxValue;   // for once-only "crossing" detection

        while (true)
        {
            await NwTask.Delay(Tick);

            // Manual override for testing: a control file fires an immediate restart.
            if (File.Exists(_controlFile))
            {
                Log.Info("[ServerRestart] control file detected — triggering immediate restart.");
                TryDelete(_controlFile);
                await ShutdownSequence();
                announced.Clear();
                prevRemaining = double.MaxValue;
                nextRestart = _target == null ? null : NextOccurrence(_target.Value);
                continue;
            }

            if (nextRestart == null) continue;

            double remaining = (nextRestart.Value - DateTime.Now).TotalMinutes;

            if (remaining <= 0)
            {
                await ShutdownSequence();
                announced.Clear();
                prevRemaining = double.MaxValue;
                nextRestart = NextOccurrence(_target!.Value);
                continue;
            }

            // Fire each warning once, as the countdown crosses below its mark. Using a
            // crossing test (prev above, now at/below) means a mid-window (re)start
            // won't retro-spam every earlier mark.
            foreach (int mark in WarnMarks)
            {
                if (!announced.Contains(mark) && remaining <= mark && prevRemaining > mark)
                {
                    Broadcast(WarnMessage(mark), mark <= 5 ? ColorConstants.Red : ColorConstants.Orange);
                    announced.Add(mark);
                }
            }
            prevRemaining = remaining;
        }
    }

    private static DateTime NextOccurrence(TimeSpan timeOfDay)
    {
        DateTime now = DateTime.Now;
        DateTime today = now.Date + timeOfDay;
        return today > now ? today : today.AddDays(1);
    }

    private static string WarnMessage(int minutes)
    {
        string unit = minutes == 1 ? "minute" : "minutes";
        return $"[Server] Scheduled restart in {minutes} {unit}. The server will reboot for {DownDuration}; "
             + "find a safe spot and expect a brief disconnect.";
    }

    private async Task ShutdownSequence()
    {
        await NwTask.SwitchToMainThread();
        Broadcast($"[Server] Restarting NOW — saving characters. Back online in {DownDuration}.",
                  ColorConstants.Red);

        // Persist every online character to the vault before the server exits.
        try { NWScript.ExportAllCharacters(); }
        catch (Exception ex) { Log.Error(ex, "[ServerRestart] ExportAllCharacters failed"); }

        // Give the export a moment to flush to disk, then shut the server down.
        await NwTask.Delay(TimeSpan.FromSeconds(3));
        Log.Info("[ServerRestart] export complete; shutting server down.");
        try { NwServer.Instance.ShutdownServer(); }
        catch (Exception ex) { Log.Error(ex, "[ServerRestart] ShutdownServer failed"); }
    }

    private static void Broadcast(string message, Color color)
    {
        foreach (NwPlayer p in NwModule.Instance.Players)
            if (p.IsValid)
                p.SendServerMessage(message, color);
        Log.Info($"[ServerRestart] broadcast: {message}");
    }

    private static void TryDelete(string path)
    {
        try { File.Delete(path); } catch { /* best-effort */ }
    }
}
