int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();
    int gqstate = GetLocalInt (oPC, "gquest");

    if (gqstate == 1)
    {
    iResult = TRUE;
    return iResult;
    }

    iResult = FALSE;
    return iResult;
}
