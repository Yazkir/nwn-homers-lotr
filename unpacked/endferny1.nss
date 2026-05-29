//::///////////////////////////////////////////////
//:: FileName endferny1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/15/2002 4:16:39 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    // Give the speaker some gold
    RewardPartyGP(200, GetPCSpeaker());

    // Give the speaker some XP
    RewardPartyXP(500, GetPCSpeaker());


    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "SharkeysOrders");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    // Set the variables
    SetLocalInt(GetPCSpeaker(), "thugtest", 2);

}
