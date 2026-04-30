void main()
{
object oPC = GetPCSpeaker();

GiveXPToCreature (oPC, 2000);
GiveGoldToCreature (oPC, 4000);

SetLocalInt (oPC, "gdquest", 3);
AddJournalQuestEntry ("gdquest1", 2, oPC, TRUE, FALSE);
}
