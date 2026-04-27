//::///////////////////////////////////////////////
//:: FileName sc_031
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/20/2002 11:56:31 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "ShimpentLetter"))
        return FALSE;

    return TRUE;
}
