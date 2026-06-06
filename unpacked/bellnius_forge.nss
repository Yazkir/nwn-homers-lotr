void main()
{
    object oPC = GetPCSpeaker();
    DelayCommand(0.1, AssignCommand(OBJECT_SELF, ActionStartConversation(oPC, "bellnius_smith", FALSE, FALSE)));
}
