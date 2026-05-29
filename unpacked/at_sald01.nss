//::///////////////////////////////////////////////
//:: FileName at_sald01
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/26/02 11:36:30 AM
//:://////////////////////////////////////////////
void main()
{
	// Set the variables
	SetLocalInt(GetPCSpeaker(), "sald", 1);

	// Open-ended (repeatable) journal entry for the Kallrist Tiger Hunt.
	AddJournalQuestEntry("Kallrist Tiger Hunt", 1, GetPCSpeaker(), FALSE, FALSE);

}
