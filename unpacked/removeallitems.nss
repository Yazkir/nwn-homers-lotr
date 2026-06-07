void ForgeLog(string sMsg)
{
    if (!GetLocalInt(GetModule(), "FORGE_DEBUG")) return;
    string sLine = "[FORGE] " + sMsg;
    WriteTimestampedLogEntry(sLine);
    SendMessageToAllDMs(sLine);
}

void main()
{
    // TEMP PROBE: visible in-game so we can confirm the greeting node (E#0) fires
    // even when file logging isn't flushed by the containerized server. Remove once
    // the forge conversation is confirmed working.
    SpeakString("FORGE-PROBE: greeting E0 fired on " + GetName(OBJECT_SELF));
    WriteTimestampedLogEntry("[FORGE] removeallitems: forge_item_mid opened on " + GetName(OBJECT_SELF));
    ForgeLog("removeallitems (forge Entry[0] fired): NPC=" + GetName(OBJECT_SELF) + " — forge_item_mid.dlg is open");
    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    while (oItem != OBJECT_INVALID)
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(OBJECT_SELF);
    }
}
