// Paths of the Dead -- StartingConditional for Aragorn's "turn in proof" branch.
// Shown only when the task has been given, the sword has not yet been granted,
// and the character actually carries the Witch-king proof right now.
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetCampaignInt("potd", "granted", oPC)) return FALSE;
    if (!GetCampaignInt("potd", "task", oPC)) return FALSE;
    if (!GetIsObjectValid(GetItemPossessedBy(oPC, "wk_proof"))) return FALSE;
    return TRUE;
}
