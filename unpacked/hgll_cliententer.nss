// hgll_cliententer — NWNX:EE port
//
// Originally cleared a queued Letoscript string left over from logout (the
// NWNX2 plugin replayed it on next login). NWNX:EE applies HGLL changes
// in-memory at the moment they happen, so there's nothing to replay.
// We still wipe the legacy locals in case they're hanging around on
// pre-port characters.

#include "pers_state_inc"

// Death amulet check + persistent state restore. Delayed so the engine's
// own post-login passes (inventory hydration, spellbook sync, "fresh PC"
// HP/spell resets) have settled before we read or override state.
void HgllPostEnter(object oPC)
{
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == "deathamulet")
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oPC);
            return;
        }
        oItem = GetNextItemInInventory(oPC);
    }

    PersState_Restore(oPC);
}

void main()
{
    object oPC = GetEnteringObject();
    SetLocalString(oPC, "LetoScript", "");
    SetLocalString(oPC, "LetoscriptLL", "");

    DelayCommand(1.0, HgllPostEnter(oPC));
}
