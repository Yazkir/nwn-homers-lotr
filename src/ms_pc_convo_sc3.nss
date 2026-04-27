//::///////////////////////////////////////////////
//:: FileName ms_pc_convo_sc3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/6/2006 6:57:52 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "ms_pc_key"))
		return FALSE;

	return TRUE;
}
