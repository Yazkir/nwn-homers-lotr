void ForgeLog(string sMsg)
{
    if (!GetLocalInt(GetModule(), "FORGE_DEBUG")) return;
    string sLine = "[FORGE] " + sMsg;
    WriteTimestampedLogEntry(sLine);
    SendMessageToAllDMs(sLine);
}

void main()
{
    object oAnvil = GetNearestObjectByTag("pAnvilOfWonder");
    string sAnvil = "NOT FOUND";
    if (oAnvil != OBJECT_INVALID) sAnvil = GetTag(oAnvil);
    ForgeLog("forge_id: NPC=" + GetName(OBJECT_SELF) + " anvil=" + sAnvil);
    if (oAnvil != OBJECT_INVALID)
    {
        object oItem = GetFirstItemInInventory(oAnvil);
        string sItem = "NONE";
        if (oItem != OBJECT_INVALID) sItem = GetName(oItem);
        ForgeLog("forge_id: item on anvil=" + sItem);
        SetIdentified(oItem, TRUE);
    }
}
