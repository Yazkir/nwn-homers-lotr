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
    // REST_CANCELLED does not clear effects, so no reapplication needed there.
    // REST_FINISHED (from ForceRest) fires synchronously mid-ForceRest, before
    // ForceRest clears effects — DelayCommand ensures we run after the wipe.
    if (nEvent == REST_EVENTTYPE_REST_FINISHED && GetLocalInt(oPC, "SPFAIL_ZONE"))
        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            EffectSpellFailure(100), oPC));
}
