// hgll_cliententer — NWNX:EE port
//
// Originally cleared a queued Letoscript string left over from logout (the
// NWNX2 plugin replayed it on next login). NWNX:EE applies HGLL changes
// in-memory at the moment they happen, so there's nothing to replay.
// We still wipe the legacy locals in case they're hanging around on
// pre-port characters.

#include "pers_state_inc"

void main()
{
    object oPC = GetEnteringObject();
    SetLocalString(oPC, "LetoScript", "");
    SetLocalString(oPC, "LetoscriptLL", "");

    object oDeathAmulet = GetFirstItemInInventory(oPC);
    effect eDeath = EffectDeath(FALSE, FALSE);
    int bDead = FALSE;
    while (GetIsObjectValid(oDeathAmulet))
    {
        if (GetTag(oDeathAmulet) == "deathamulet")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
            bDead = TRUE;
            break;
        }
        oDeathAmulet = GetNextItemInInventory(oPC);
    }

    // Restore HP / spell slots / feat uses captured at logout. Delay
    // so the engine's own client-enter "rested" reset has settled.
    // Skip when the deathamulet path already killed them this tick.
    if (!bDead) DelayCommand(0.5, PersState_Restore(oPC));
}
