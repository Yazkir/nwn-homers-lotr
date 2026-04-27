void main()
{
    object oPC = GetLastSpeaker();
    object oPlayer = GetFirstPC();
    string sMsg = "[ Name ] and [ Location ]\n-------------------------\n";

    while (GetIsObjectValid(oPlayer))
    {
        if (GetIsDM(oPlayer) == TRUE)
        {
            sMsg = sMsg + "[" + GetName(oPlayer) + "] is located at [";
            sMsg = sMsg + GetName(GetAreaFromLocation(GetLocation(oPlayer))) + "].\n";
        }
        oPlayer = GetNextPC();
    }
    SendMessageToPC(oPC, sMsg);
}
