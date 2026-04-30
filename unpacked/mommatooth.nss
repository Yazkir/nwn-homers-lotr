//::///////////////////////////////////////////////
//:: FileName mommatooth
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/9/2002 4:09:30 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "BigMommasToken"))
        return FALSE;

    return TRUE;
}
