void main()
{
    effect eFail = GetFirstEffect(GetExitingObject());
    while (GetIsEffectValid(eFail))
    {
        if ((GetEffectType(eFail) == EFFECT_TYPE_SPELL_FAILURE) &&
            (GetEffectDurationType(eFail) == DURATION_TYPE_PERMANENT))
        {
            RemoveEffect(GetExitingObject(), eFail);
        }
        eFail = GetNextEffect(GetExitingObject());
    }
}

