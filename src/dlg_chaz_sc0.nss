//::///////////////////////////////////////////////
//:: FileName dlg_chaz_sc0
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/8/2006 6:43:13 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "ms_pc_key"))
		return FALSE;

	return TRUE;
}
