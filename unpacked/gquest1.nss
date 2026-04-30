int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();
    int gqstate = GetLocalInt (oPC, "gquest");

    if (gqstate == 0)
    {
    iResult = TRUE;
    return iResult;
    }

    iResult = FALSE;
    return iResult;
}
