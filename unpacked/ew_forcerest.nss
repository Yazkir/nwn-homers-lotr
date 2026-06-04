#include "pers_state_inc"

void main()
{
    object oPC = GetPCSpeaker();
    ForceRest(oPC);
    // Belt-and-suspenders: reapply spell-fail zone effect after ForceRest
    // clears it, in case the REST_FINISHED event handler fires too early.
    if (GetLocalInt(oPC, "SPFAIL_ZONE"))
        DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            EffectSpellFailure(100), oPC));
    // Snapshot freshly-rested HP / spells / feats so a logout
    // immediately after the emotewand instant-rest restores correctly.
    DelayCommand(0.5, PersState_Snapshot(oPC));
}
