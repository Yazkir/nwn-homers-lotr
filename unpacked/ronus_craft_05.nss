//::///////////////////////////////////////////////
//:: FileName ronus_craft_05
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/28/2005 9:50:06 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "theperfectarrowhead"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "pureonyx"))
        return FALSE;

    return TRUE;
}
