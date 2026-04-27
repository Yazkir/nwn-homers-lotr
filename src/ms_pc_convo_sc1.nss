// Only shows this text if the chest
// is in use by someone else so BACK OFF!
int StartingConditional()
{
    string sCDKey = GetPCPublicCDKey(GetPCSpeaker());

    object oContainer = GetNearestObjectByTag("PERSISTENT_CHEST", GetPCSpeaker());

    string sOwnerID = GetLocalString(oContainer, "OWNER_ID");

    if (!GetIsObjectValid(oContainer)) return FALSE;

    if (sCDKey != sOwnerID || sOwnerID != "") return TRUE;

    return FALSE;
}
