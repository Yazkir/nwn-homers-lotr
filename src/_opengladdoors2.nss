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

ActionSpeakString("Opening cell doors silently.");

SetLocked(oDoor1, FALSE);
SetLocked(oDoor2, FALSE);
SetLocked(oDoor3, FALSE);
SetLocked(oDoor4, FALSE);
SetLocked(oDoor5, FALSE);
SetLocked(oDoor6, FALSE);
SetLocked(oDoor7, FALSE);
SetLocked(oDoor8, FALSE);
SetLocked(oDoor9, FALSE);
SetLocked(oDoor10, FALSE);
SetLocked(oDoor11, FALSE);
SetLocked(oDoor12, FALSE);

AssignCommand(oDoor1, ActionOpenDoor(oDoor1));
AssignCommand(oDoor2, ActionOpenDoor(oDoor2));
AssignCommand(oDoor3, ActionOpenDoor(oDoor3));
AssignCommand(oDoor4, ActionOpenDoor(oDoor4));
AssignCommand(oDoor5, ActionOpenDoor(oDoor5));
AssignCommand(oDoor6, ActionOpenDoor(oDoor6));
AssignCommand(oDoor7, ActionOpenDoor(oDoor7));
AssignCommand(oDoor8, ActionOpenDoor(oDoor8));
AssignCommand(oDoor9, ActionOpenDoor(oDoor9));
AssignCommand(oDoor10, ActionOpenDoor(oDoor10));
AssignCommand(oDoor11, ActionOpenDoor(oDoor11));
AssignCommand(oDoor12, ActionOpenDoor(oDoor12));
}
