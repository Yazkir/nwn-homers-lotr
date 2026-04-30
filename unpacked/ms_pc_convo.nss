void main()
{
    object oPC = GetLastSpeaker();

    ActionStartConversation(oPC, "ms_pc_convo", TRUE, FALSE);

    DelayCommand(30.0, ExecuteScript("ms_pc_prox", OBJECT_SELF));
}
