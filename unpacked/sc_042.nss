//::///////////////////////////////////////////////
//:: FileName sc_042
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/9/2002 4:51:53 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!CheckPartyForItem(GetPCSpeaker(), "TheMysticHeirloom"))
		return FALSE;

	return TRUE;
}
