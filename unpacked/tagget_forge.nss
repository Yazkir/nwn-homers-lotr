void ForgeLog(string sMsg)
{
    if (!GetLocalInt(GetModule(), "FORGE_DEBUG")) return;
    string sLine = "[FORGE] " + sMsg;
    WriteTimestampedLogEntry(sLine);
    SendMessageToAllDMs(sLine);
}

void main()
{
    object oPC = GetPCSpeaker();
    ForgeLog("tagget_forge fired. NPC=" + GetName(OBJECT_SELF) + " PC=" + GetName(oPC));
    DelayCommand(0.1, AssignCommand(OBJECT_SELF, ClearAllActions(TRUE)));
    ForgeLog("ClearAllActions queued at t+0.1");
    DelayCommand(0.2, AssignCommand(OBJECT_SELF, ActionStartConversation(oPC, "forge_item_mid", FALSE, FALSE)));
    ForgeLog("ActionStartConversation(forge_item_mid) queued at t+0.2");
}
