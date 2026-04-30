//::///////////////////////////////////////////////
//:: FileName at_073
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/11/2002 2:38:24 PM
//:://////////////////////////////////////////////
void main()
{
	// Give the speaker the items
	CreateItemOnObject("contestofchampio", GetPCSpeaker(), 1);


	// Remove some gold from the player
	TakeGoldFromCreature(10, GetPCSpeaker(), TRUE);
}
