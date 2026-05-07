#include "pers_state_inc"

void main()
{
    object oPC = GetPCSpeaker();
    ForceRest(oPC);
    DelayCommand(0.5, PersState_Snapshot(oPC));
}
