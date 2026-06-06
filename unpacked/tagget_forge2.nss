void main()
{
    object oPC = GetLocalObject(OBJECT_SELF, "FORGE_PC");
    DeleteLocalObject(OBJECT_SELF, "FORGE_PC");
    ClearAllActions(TRUE);
    ActionStartConversation(oPC, "forge_item_mid", FALSE, TRUE);
}
