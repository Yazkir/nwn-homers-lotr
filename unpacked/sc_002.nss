//::///////////////////////////////////////////////
//:: FileName sc_002
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/15/2002 4:29:17 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!CheckPlayerForItem(GetPCSpeaker(), "SharkeysOrders"))
        return FALSE;

    return TRUE;
}
