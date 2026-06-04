void main()
{
    object oEntering = GetEnteringObject();
    SetLocalInt(oEntering, "SPFAIL_ZONE", 1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
        EffectSpellFailure(EFFECT_TYPE_SPELL_FAILURE), oEntering);
}
