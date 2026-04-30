//::///////////////////////////////////////////////
//:: FileName sc_012
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/8/2002 12:00:39 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "ElrondsWrit"))
        return FALSE;

    return TRUE;
}
