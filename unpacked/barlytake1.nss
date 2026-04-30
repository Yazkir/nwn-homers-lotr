//::///////////////////////////////////////////////
//:: FileName barlytake1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/14/2002 11:55:44 PM
//:://////////////////////////////////////////////
void main()
{
	// Give the speaker the items
	CreateItemOnObject("bree_room_key006", GetPCSpeaker(), 1);


	// Remove some gold from the player
	TakeGoldFromCreature(15, GetPCSpeaker(), FALSE);
}
