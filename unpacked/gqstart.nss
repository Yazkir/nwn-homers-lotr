void main()
{

object oPC = GetPCSpeaker();
SetLocalInt (oPC, "gquest", 1);

AddJournalQuestEntry ("gwathquest", 1, oPC, TRUE, FALSE);
}
