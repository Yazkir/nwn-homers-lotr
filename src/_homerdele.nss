void main()
{
    object oPC = GetLastUsedBy();
    AssignCommand(oPC, ActionStartConversation(oPC, "j_deleteme"));
}
