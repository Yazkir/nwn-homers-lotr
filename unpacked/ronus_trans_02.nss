//::///////////////////////////////////////////////
//:: FileName ronus_trans_02
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/18/2005 11:30:36 AM
//:://////////////////////////////////////////////
void main()
{
	// Give the speaker the items
	CreateItemOnObject("epickatanaofther", GetPCSpeaker(), 1);


	// Remove items from the player's inventory
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "StolenHammer");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
