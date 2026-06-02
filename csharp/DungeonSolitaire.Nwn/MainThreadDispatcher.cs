using System.Collections.Concurrent;
using Anvil.API;
using Anvil.Services;
using NLog;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Serializes work onto Anvil's main thread.
///
/// The Dungeon Solitaire engine runs on a background thread (RunTurn() blocks on
/// player input / effect acknowledgement), and raises GameEventBus events on that
/// thread. Anvil's game API is main-thread only, so the engine listener enqueues
/// units of work here; this pump drains them in order on the main thread, awaiting
/// each one fully so animations play sequentially — the NWN analogue of Godot's
/// CallDeferred + await.
/// </summary>
[ServiceBinding(typeof(MainThreadDispatcher))]
internal sealed class MainThreadDispatcher
{
    private static readonly Logger Log = LogManager.GetCurrentClassLogger();
    private readonly ConcurrentQueue<Func<Task>> _queue = new();
    private volatile bool _running = true;

    public MainThreadDispatcher()
    {
        _ = Pump();
    }

    /// <summary>Queue an async unit of work to run (awaited to completion, in order) on the main thread.</summary>
    public void Enqueue(Func<Task> work) => _queue.Enqueue(work);

    /// <summary>Queue a synchronous unit of work on the main thread.</summary>
    public void Enqueue(System.Action work) => _queue.Enqueue(() => { work(); return Task.CompletedTask; });

    private async Task Pump()
    {
        await NwTask.SwitchToMainThread();
        while (_running)
        {
            if (_queue.TryDequeue(out Func<Task>? work))
            {
                try { await work(); }
                catch (Exception ex) { Log.Error(ex, "[DungeonSolitaire] main-thread work item threw"); }
            }
            else
            {
                await NwTask.NextFrame();
            }
        }
    }
}
