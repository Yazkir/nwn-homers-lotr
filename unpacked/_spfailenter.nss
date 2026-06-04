void main()
{
    object oEntering = GetEnteringObject();
    SetLocalInt(oEntering, "SPFAIL_ZONE", 1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
        EffectSpellFailure(100), oEntering);
}
