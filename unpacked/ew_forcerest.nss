#include "pers_state_inc"

void main()
{
    object oPC = GetPCSpeaker();
    ForceRest(oPC);
    // Snapshot freshly-rested HP / spells / feats so a logout
    // immediately after the emotewand instant-rest restores correctly.
    DelayCommand(0.5, PersState_Snapshot(oPC));
}
