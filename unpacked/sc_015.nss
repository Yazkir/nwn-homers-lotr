//::///////////////////////////////////////////////
//:: FileName sc_015
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/8/2002 1:45:42 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!CheckPartyForItem(GetPCSpeaker(), "MutantsHead"))
		return FALSE;
	if(!CheckPartyForItem(GetPCSpeaker(), "HelmoftheWarlord"))
		return FALSE;

	return TRUE;
}
