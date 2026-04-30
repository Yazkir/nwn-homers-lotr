//::///////////////////////////////////////////////
//:: FileName ronus_craft_01
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/18/2005 10:31:45 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "AMagicalScale"))
		return FALSE;
	if(!HasItem(GetPCSpeaker(), "APerfectMarble"))
		return FALSE;
	if(!HasItem(GetPCSpeaker(), "FineSilk"))
		return FALSE;

	return TRUE;
}
