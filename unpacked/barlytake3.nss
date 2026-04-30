//::///////////////////////////////////////////////
//:: FileName barlytake3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/14/2002 11:57:12 PM
//:://////////////////////////////////////////////
void main()
{
	// Give the speaker the items
	CreateItemOnObject("bree_room_key_su", GetPCSpeaker(), 1);


	// Remove some gold from the player
	TakeGoldFromCreature(30, GetPCSpeaker(), FALSE);
}
