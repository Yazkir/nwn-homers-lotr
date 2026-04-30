void main()
{

{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetItemPossessedBy(oPC, "ArenaKey")== OBJECT_INVALID)
   return;

}

object oDoor1 = GetObjectByTag("GladiatorDoor1");
object oDoor2 = GetObjectByTag("GladiatorDoor2");
object oDoor3 = GetObjectByTag("GladiatorDoor3");
object oDoor4 = GetObjectByTag("GladiatorDoor4");
object oDoor5 = GetObjectByTag("GladiatorDoor5");
object oDoor6 = GetObjectByTag("GladiatorDoor6");
object oDoor7 = GetObjectByTag("GladiatorDoor7");
object oDoor8 = GetObjectByTag("GladiatorDoor8");
object oDoor9 = GetObjectByTag("GladiatorDoor9");
object oDoor10 = GetObjectByTag("GladiatorDoor10");
object oDoor11 = GetObjectByTag("GladiatorDoor11");
object oDoor12 = GetObjectByTag("GladiatorDoor12");

ActionSpeakString("Opening cell doors.");

{
DelayCommand(1.0, AssignCommand(GetObjectByTag("Speaker"), ActionSpeakString("5 seconds until the battle begins!")));
DelayCommand(1.0, AssignCommand(GetObjectByTag("Speaker2"), ActionSpeakString("5 seconds until the battle begins!")));
DelayCommand(1.0, AssignCommand(GetObjectByTag("Speaker3"), ActionSpeakString("5 seconds until the battle begins!")));
DelayCommand(1.0, AssignCommand(GetObjectByTag("Speaker4"), ActionSpeakString("5 seconds until the battle begins!")));
DelayCommand(6.0, AssignCommand(GetObjectByTag("Speaker"), ActionSpeakString("Go!")));
DelayCommand(6.0, AssignCommand(GetObjectByTag("Speaker2"), ActionSpeakString("Go!")));
DelayCommand(6.0, AssignCommand(GetObjectByTag("Speaker3"), ActionSpeakString("Go!")));
DelayCommand(6.0, AssignCommand(GetObjectByTag("Speaker4"), ActionSpeakString("Go!")));
}

{
DelayCommand(6.0, SetLocked(oDoor1, FALSE));
DelayCommand(6.0, SetLocked(oDoor2, FALSE));
DelayCommand(6.0, SetLocked(oDoor3, FALSE));
DelayCommand(6.0, SetLocked(oDoor4, FALSE));
DelayCommand(6.0, SetLocked(oDoor5, FALSE));
DelayCommand(6.0, SetLocked(oDoor6, FALSE));
DelayCommand(6.0, SetLocked(oDoor7, FALSE));
DelayCommand(6.0, SetLocked(oDoor8, FALSE));
DelayCommand(6.0, SetLocked(oDoor9, FALSE));
DelayCommand(6.0, SetLocked(oDoor10, FALSE));
DelayCommand(6.0, SetLocked(oDoor11, FALSE));
DelayCommand(6.0, SetLocked(oDoor12, FALSE));
}

{
DelayCommand(6.0, AssignCommand(oDoor1, ActionOpenDoor(oDoor1)));
DelayCommand(6.0, AssignCommand(oDoor2, ActionOpenDoor(oDoor2)));
DelayCommand(6.0, AssignCommand(oDoor3, ActionOpenDoor(oDoor3)));
DelayCommand(6.0, AssignCommand(oDoor4, ActionOpenDoor(oDoor4)));
DelayCommand(6.0, AssignCommand(oDoor5, ActionOpenDoor(oDoor5)));
DelayCommand(6.0, AssignCommand(oDoor6, ActionOpenDoor(oDoor6)));
DelayCommand(6.0, AssignCommand(oDoor7, ActionOpenDoor(oDoor7)));
DelayCommand(6.0, AssignCommand(oDoor8, ActionOpenDoor(oDoor8)));
DelayCommand(6.0, AssignCommand(oDoor9, ActionOpenDoor(oDoor9)));
DelayCommand(6.0, AssignCommand(oDoor10, ActionOpenDoor(oDoor10)));
DelayCommand(6.0, AssignCommand(oDoor11, ActionOpenDoor(oDoor11)));
DelayCommand(6.0, AssignCommand(oDoor12, ActionOpenDoor(oDoor12)));
}
}
