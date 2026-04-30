//::///////////////////////////////////////////////
//:: FileName sc_sald05
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/26/02 2:38:55 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "kallristtigerhea"))
        return FALSE;

    return TRUE;
}
