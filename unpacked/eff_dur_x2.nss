// eff_dur_x2 -- Double the duration of every temporary effect a player creates.
//
// Subscribed to NWNX_ON_EFFECT_APPLIED_AFTER in onmoduleload.nss. Fires once for
// every Temporary or Permanent effect applied to any object server-wide (visual
// effects and item properties do not fire this event). OBJECT_SELF is the effect
// target.
//
// Scope (per design): only effects whose CREATOR is a player character get doubled
// -- buffs a PC casts, potions/scrolls they use, and debuffs they inflict. Effects
// an enemy places on a PC are left alone.
//
// We locate the just-applied effect by its UNIQUE_ID (matched against the unpacked
// effect's sID), then overwrite only its duration via ReplaceEffectByIndex. Working
// on the live internal effect this way preserves linked sub-effects (icon/visual/
// bonus), unlike rebuilding the effect from raw event data. If the id match ever
// fails the handler simply does nothing -- a buff stays at its normal length rather
// than getting corrupted (safe failure mode).
//
// Note: this stacks with the Extend metamagic. Extend already doubles a spell's
// duration in its own script, so an Extended buff ends up 4x base. That is intended.

#include "nwnx_events"
#include "nwnx_effect"

void main()
{
    object oTarget = OBJECT_SELF;

    // Re-entrancy guard (belt-and-suspenders -- ReplaceEffectByIndex edits in place
    // and should not re-fire this event, but never double the same effect twice).
    if (GetLocalInt(oTarget, "x2dur_busy"))
        return;

    // Only temporary (timed) effects have a meaningful duration to extend.
    if (StringToInt(NWNX_Events_GetEventData("DURATION_TYPE")) != DURATION_TYPE_TEMPORARY)
        return;

    // Scope: only effects created by a player character.
    object oCreator = StringToObject(NWNX_Events_GetEventData("CREATOR"));
    if (!GetIsPC(oCreator))
        return;

    float fDur = StringToFloat(NWNX_Events_GetEventData("DURATION"));
    if (fDur <= 0.0)
        return;

    // Requires the NWNX_Effect plugin (NWNX_EFFECT_SKIP=n in server.env).

    // Optional: spells whose duration is deliberately fixed and should NOT double can
    // be excluded here, e.g.:
    //   int nSpell = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
    //   if (nSpell == SPELL_SUMMON_CREATURE_IX) return;

    string sUID = NWNX_Events_GetEventData("UNIQUE_ID");

    int nCount = NWNX_Effect_GetTrueEffectCount(oTarget);
    int i;
    for (i = 0; i < nCount; i++)
    {
        struct NWNX_EffectUnpacked e = NWNX_Effect_GetTrueEffect(oTarget, i);
        if (e.sID == sUID)
        {
            e.fDuration = fDur * 2.0;
            SetLocalInt(oTarget, "x2dur_busy", TRUE);
            NWNX_Effect_ReplaceEffectByIndex(oTarget, i, e);
            DeleteLocalInt(oTarget, "x2dur_busy");
            break;
        }
    }
}
