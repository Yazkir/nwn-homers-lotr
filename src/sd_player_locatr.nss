void main()
{
    object oPC = GetLastUsedBy();
    object oPlayer = GetFirstPC();
    string sMsg = "[ NAME ] and [ LOCATION ]\n-------------------------\n";

    while (GetIsObjectValid(oPlayer))
    {
        if (GetIsDM(oPlayer) == FALSE)
        {
            sMsg = sMsg + "[" + GetName(oPlayer) + "] is located at [";
            sMsg = sMsg + GetName(GetAreaFromLocation(GetLocation(oPlayer))) + "].\n";
        }
        oPlayer = GetNextPC();
    }
    SendMessageToPC(oPC, sMsg);
}
