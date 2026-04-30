//::///////////////////////////////////////////////
//:: FileName sc_kashan03
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/26/02 11:05:55 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "Troyspin"))
        return FALSE;

    return TRUE;
}
