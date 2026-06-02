using Anvil.API;

namespace DungeonSolitaire.Nwn;

/// <summary>
/// Maps Dungeon Solitaire effect names to NWN visual effects, mirroring the
/// Godot front-end's SpawnEffectParticles / PlayEffectSound switch. Keyed by the
/// engine effect name (string) so this file stays free of the engine's Effect
/// type (which collides with Anvil.API.Effect).
/// </summary>
internal static class Vfx
{
    /// <summary>Fire-and-forget visual played on the source/area when an effect activates.</summary>
    public static VfxType ForEffect(string? effectName) => (effectName ?? "").ToLowerInvariant() switch
    {
        var n when n.Contains("firestorm") || n.Contains("scorch") || n.Contains("flame") => VfxType.FnfFirestorm,
        var n when n.Contains("fire")                                                     => VfxType.FnfFireball,
        var n when n.Contains("blizzard") || n.Contains("flood") || n.Contains("frost") || n.Contains("ice") => VfxType.FnfIcestorm,
        var n when n.Contains("arc") || n.Contains("lightning") || n.Contains("thunder")  => VfxType.ImpLightningM,
        var n when n.Contains("renew") || n.Contains("heal") || n.Contains("restor") || n.Contains("regenerat") => VfxType.FnfMassHeal,
        var n when n.Contains("blind") || n.Contains("veil")                              => VfxType.ImpBlindDeafM,
        var n when n.Contains("silence") || n.Contains("hush")                            => VfxType.ImpSilence,
        var n when n.Contains("petrif") || n.Contains("stone")                            => VfxType.ImpPolymorph,
        var n when n.Contains("raise") || n.Contains("resurrect") || n.Contains("soul")   => VfxType.ImpRaiseDead,
        var n when n.Contains("plague") || n.Contains("disease") || n.Contains("infest")  => VfxType.ImpPulseNegative,
        var n when n.Contains("eclipse") || n.Contains("moonlight") || n.Contains("solar")=> VfxType.FnfLosHoly20,
        var n when n.Contains("prismatic") || n.Contains("foresight") || n.Contains("palantir") => VfxType.ImpMagblue,
        _ => VfxType.FnfMysticalExplosion,
    };

    /// <summary>Impact visual applied to the defender when an ally lands a hit.</summary>
    public const VfxType MeleeImpact = VfxType.ComBloodLrgRed;

    /// <summary>Visual when an enemy card is revealed (statue → creature).</summary>
    public const VfxType Reveal = VfxType.ImpUnsummon;

    /// <summary>Visual when a card actor appears (spawn).</summary>
    public const VfxType Appear = VfxType.ImpMagblue;
}
