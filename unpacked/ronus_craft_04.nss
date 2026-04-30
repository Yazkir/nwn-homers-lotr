//::///////////////////////////////////////////////
//:: FileName ronus_craft_04
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/18/2005 11:59:24 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "DuelPowerStones"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "PureOnyx"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "WeatherStone"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "WhiteGold"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "BlackGalvornPlate"))
        return FALSE;

    return TRUE;
}
