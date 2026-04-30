//::///////////////////////////////////////////////
//:: FileName at_001
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/15/2002 1:26:56 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
	// Give the speaker some XP
	RewardPartyXP(300, GetPCSpeaker());


	// Remove items from the player's inventory
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "ShimpentLetter");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
