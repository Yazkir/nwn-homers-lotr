//::///////////////////////////////////////////////
//:: FileName barli_take
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/14/2002 11:54:48 PM
//:://////////////////////////////////////////////
void main()
{
	// Give the speaker the items
	CreateItemOnObject("bree_room_key_ba", GetPCSpeaker(), 1);


	// Remove some gold from the player
	TakeGoldFromCreature(10, GetPCSpeaker(), FALSE);
}
