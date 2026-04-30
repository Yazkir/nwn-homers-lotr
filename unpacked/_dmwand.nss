void main()
{
object oPC = GetLastSpeaker();

AssignCommand(oPC, ActionStartConversation(OBJECT_SELF, "dmwand", TRUE));
}

