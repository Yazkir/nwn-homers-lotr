//::///////////////////////////////////////////////
//:: FileName ronus_craft_03
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/18/2005 11:38:38 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "DuelPowerStones"))
		return FALSE;
	if(!HasItem(GetPCSpeaker(), "ImbunedStone"))
		return FALSE;
	if(!HasItem(GetPCSpeaker(), "X2_IT_MGLOVE018"))
		return FALSE;

	return TRUE;
}
