void main()
{
    object oPC = GetLastSpeaker();
    AdjustReputation(oPC, GetObjectByTag("Goodfaction"), -100);
    AdjustReputation(oPC, GetObjectByTag("Evilfaction"), 1000);
    AdjustReputation(oPC, GetObjectByTag("Neutralfaction"), -100);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_20), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_EVIL), oPC);
}
