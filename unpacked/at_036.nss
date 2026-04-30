//::///////////////////////////////////////////////
//:: FileName at_036
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/12/2002 10:41:54 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    // Give the speaker some gold
    RewardPartyGP(10000, GetPCSpeaker());

    // Give the speaker some XP
    RewardPartyXP(2000, GetPCSpeaker());


    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "NW_WPLMSC004");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
