// Only shows this text if the chest
// has never been used before.
int StartingConditional()
{
    string sCDKey = GetPCPublicCDKey(GetPCSpeaker());

    object oContainer = GetNearestObjectByTag("PERSISTENT_CHEST", GetPCSpeaker());

    string sOwnerID = GetLocalString(oContainer, "OWNER_ID");

    if (!GetIsObjectValid(oContainer)) return FALSE;

    if (sOwnerID == "") return TRUE;

    return FALSE;
}
