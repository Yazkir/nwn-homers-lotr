//::///////////////////////////////////////////////
//:: FileName sc_004
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/25/2002 9:46:01 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "Athelas"))
        return FALSE;
    if(!CheckPlayerForItem(GetPCSpeaker(), "EssenseofIceDrake"))
        return FALSE;
    if(!CheckPlayerForItem(GetPCSpeaker(), "StonefromArathorn"))
        return FALSE;

    return TRUE;
}
