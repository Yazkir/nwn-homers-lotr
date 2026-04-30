int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();
    int gqstate = GetLocalInt (oPC, "gquest");

    if (gqstate == 2)
    {
    iResult = TRUE;
    return iResult;
    }

    iResult = FALSE;
    return iResult;
}

