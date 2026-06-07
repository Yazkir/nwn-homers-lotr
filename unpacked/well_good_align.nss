void main()
{
    object oPC = GetLastSpeaker();
    AdjustReputation(oPC, GetObjectByTag("Goodfaction"), 1000);
    AdjustReputation(oPC, GetObjectByTag("Evilfaction"), -100);
    AdjustReputation(oPC, GetObjectByTag("Neutralfaction"), -100);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_HOLY), oPC);
}
