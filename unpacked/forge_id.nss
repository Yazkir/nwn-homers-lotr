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
    ForgeLog("forge_id: NPC=" + GetName(OBJECT_SELF) + " anvil=" + (oAnvil != OBJECT_INVALID ? GetTag(oAnvil) : "NOT FOUND"));
    if (oAnvil != OBJECT_INVALID)
    {
        object oItem = GetFirstItemInInventory(oAnvil);
        ForgeLog("forge_id: item on anvil=" + (oItem != OBJECT_INVALID ? GetName(oItem) : "NONE"));
        SetIdentified(oItem, TRUE);
    }
}
