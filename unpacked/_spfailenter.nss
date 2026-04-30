void main()
{
    effect eFail = EffectSpellFailure(EFFECT_TYPE_SPELL_FAILURE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFail, GetEnteringObject());
}
