void main()
{
    object oExiting = GetExitingObject();
    DeleteLocalInt(oExiting, "SPFAIL_ZONE");
    effect eFail = GetFirstEffect(oExiting);
    while (GetIsEffectValid(eFail))
    {
        if ((GetEffectType(eFail) == EFFECT_TYPE_SPELL_FAILURE) &&
            (GetEffectDurationType(eFail) == DURATION_TYPE_PERMANENT))
        {
            RemoveEffect(oExiting, eFail);
        }
        eFail = GetNextEffect(oExiting);
    }
}

