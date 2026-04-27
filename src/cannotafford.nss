int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iDiff = GetLocalInt(oPC, "MODIFY_DIFF");
    if (iDiff = 1)
        {
        int iValue = GetLocalInt(oPC, "MODIFY_VALUE");
        int iGold = GetGold(oPC);
        return( iGold < iValue);
        }
    else
        return FALSE;
}
