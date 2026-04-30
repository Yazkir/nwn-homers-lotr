void main()
{

{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetItemPossessedBy(oPC, "ArenaKey")== OBJECT_INVALID)
   return;

}

object oTarget12 = GetObjectByTag("GladiatorDoor12");
object oTarget1 = GetObjectByTag("GladiatorDoor1");
object oTarget2 = GetObjectByTag("GladiatorDoor2");
object oTarget3 = GetObjectByTag("GladiatorDoor3");
object oTarget4 = GetObjectByTag("GladiatorDoor4");
object oTarget5 = GetObjectByTag("GladiatorDoor5");
object oTarget6 = GetObjectByTag("GladiatorDoor6");
object oTarget7 = GetObjectByTag("GladiatorDoor7");
object oTarget8 = GetObjectByTag("GladiatorDoor8");
object oTarget9 = GetObjectByTag("GladiatorDoor9");
object oTarget10 = GetObjectByTag("GladiatorDoor10");
object oTarget11 = GetObjectByTag("GladiatorDoor11");

ActionSpeakString("Closing cell doors.", TALKVOLUME_WHISPER);

DelayCommand(1.0, AssignCommand(oTarget1, ActionCloseDoor(oTarget1)));
DelayCommand(1.0, AssignCommand(oTarget2, ActionCloseDoor(oTarget2)));
DelayCommand(1.0, AssignCommand(oTarget3, ActionCloseDoor(oTarget3)));
DelayCommand(1.0, AssignCommand(oTarget4, ActionCloseDoor(oTarget4)));
DelayCommand(1.0, AssignCommand(oTarget5, ActionCloseDoor(oTarget5)));
DelayCommand(1.0, AssignCommand(oTarget6, ActionCloseDoor(oTarget6)));
DelayCommand(1.0, AssignCommand(oTarget7, ActionCloseDoor(oTarget7)));
DelayCommand(1.0, AssignCommand(oTarget8, ActionCloseDoor(oTarget8)));
DelayCommand(1.0, AssignCommand(oTarget9, ActionCloseDoor(oTarget9)));
DelayCommand(1.0, AssignCommand(oTarget10, ActionCloseDoor(oTarget10)));
DelayCommand(1.0, AssignCommand(oTarget11, ActionCloseDoor(oTarget11)));
DelayCommand(1.0, AssignCommand(oTarget12, ActionCloseDoor(oTarget12)));

SetLocked(oTarget1, TRUE);
SetLocked(oTarget2, TRUE);
SetLocked(oTarget3, TRUE);
SetLocked(oTarget4, TRUE);
SetLocked(oTarget5, TRUE);
SetLocked(oTarget6, TRUE);
SetLocked(oTarget7, TRUE);
SetLocked(oTarget8, TRUE);
SetLocked(oTarget9, TRUE);
SetLocked(oTarget10, TRUE);
SetLocked(oTarget11, TRUE);
SetLocked(oTarget12, TRUE);
}
