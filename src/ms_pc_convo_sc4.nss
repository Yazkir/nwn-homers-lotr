int StartingConditional()
{
    string sCDKey = GetPCPublicCDKey(GetPCSpeaker());

    object oContainer = OBJECT_SELF;

    string sOwnerID = GetLocalString(oContainer, "OWNER_ID");

    if (sOwnerID == sCDKey) return TRUE;

    return FALSE;
}
