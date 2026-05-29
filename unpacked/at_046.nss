//::///////////////////////////////////////////////
//:: FileName at_046
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/16/2002 11:04:30 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    // Give the speaker some XP
    RewardPartyXP(500, GetPCSpeaker());

    // Give the speaker the items
    CreateItemOnObject("bookofthecora", GetPCSpeaker(), 1);

    // Set the variables
    SetLocalInt(GetPCSpeaker(), "agreefeed", 3);

}
