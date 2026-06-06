void main()
{
    object oPC = GetPCSpeaker();
    SetLocalObject(OBJECT_SELF, "FORGE_PC", oPC);
    DelayCommand(0.05, ExecuteScript("tagget_forge2", OBJECT_SELF));
}
