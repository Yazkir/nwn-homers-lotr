// Paths of the Dead -- StartingConditional for Aragorn's "set the task" branch.
// Shown only when the character has not yet been given the proving task and has
// not already received Anduril (honourably or by force).
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetCampaignInt("potd", "granted", oPC)) return FALSE;
    if (GetCampaignInt("potd", "task", oPC)) return FALSE;
    return TRUE;
}
