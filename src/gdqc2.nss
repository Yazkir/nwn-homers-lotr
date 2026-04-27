void main()
{
object oPC = GetPCSpeaker();

SetLocalInt (oPC, "gdquest", 2);

//spawn henchmen
location LHS1 = GetLocation(GetObjectByTag("gdsh1"));
location LHS2 = GetLocation(GetObjectByTag("gdsh2"));
location LHS3 = GetLocation(GetObjectByTag("gdsh3"));
CreateObject (OBJECT_TYPE_CREATURE, "henchmanofsharke", LHS1, FALSE);
CreateObject (OBJECT_TYPE_CREATURE, "henchmanofsharke", LHS2, FALSE);
CreateObject (OBJECT_TYPE_CREATURE, "henchmanofsharke", LHS3, FALSE);

AddJournalQuestEntry ("gdquest1", 1, oPC, TRUE, FALSE);
}
