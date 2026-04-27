void main()
{
object oPC = GetPCSpeaker();

GiveXPToCreature (oPC, 500);
GiveGoldToCreature (oPC, 1000);

SetLocalInt (oPC, "gdquest", 3);
AddJournalQuestEntry ("gdquest1", 2, oPC, TRUE, FALSE);
}
