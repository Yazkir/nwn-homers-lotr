void main()
{
    object oPC = GetPCSpeaker();
    WriteTimestampedLogEntry("[FORGE] tagget_forge: NPC=" + GetName(OBJECT_SELF) + " PC=" + GetName(oPC));
    SendMessageToAllDMs("[FORGE] tagget_forge fired - queuing forge_item_mid");
    DelayCommand(0.1, AssignCommand(OBJECT_SELF, ActionStartConversation(oPC, "forge_item_mid", FALSE, FALSE)));
}
