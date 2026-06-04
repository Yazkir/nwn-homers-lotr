#include "pers_state_inc"

void main()
{
    object oPC = GetPCSpeaker();
    ForceRest(oPC);
    if (GetLocalInt(oPC, "SPFAIL_ZONE"))
        DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            EffectSpellFailure(100), oPC));
    DelayCommand(0.5, PersState_Snapshot(oPC));
}
