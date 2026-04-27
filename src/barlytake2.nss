//::///////////////////////////////////////////////
//:: FileName barlytake2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/14/2002 11:56:25 PM
//:://////////////////////////////////////////////
void main()
{
	// Give the speaker the items
	CreateItemOnObject("bree_room_key007", GetPCSpeaker(), 1);


	// Remove some gold from the player
	TakeGoldFromCreature(25, GetPCSpeaker(), FALSE);
}
