void main()
{
    object oPC = GetLastPCRested();
    int iMamber = GetCampaignInt("cRegistred","iMamber",oPC);
    int nEvent = GetLastRestEventType();
    if (nEvent == REST_EVENTTYPE_REST_STARTED)
    {
        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, ActionStartConversation(oPC, "emotewand", TRUE));
        return;
    }
    if ((nEvent == REST_EVENTTYPE_REST_FINISHED || nEvent == REST_EVENTTYPE_REST_CANCELLED) &&
        GetLocalInt(oPC, "SPFAIL_ZONE"))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            EffectSpellFailure(EFFECT_TYPE_SPELL_FAILURE), oPC);
    }
}
