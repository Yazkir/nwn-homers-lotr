//::///////////////////////////////////////////////
//:: FileName sc_003
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/21/2002 11:48:43 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "azagothshead"))
        return FALSE;

    return TRUE;
}
