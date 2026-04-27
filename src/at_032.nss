//::///////////////////////////////////////////////
//:: FileName at_032
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/10/2002 10:29:24 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    // Give the speaker some XP
    RewardPartyXP(1000, GetPCSpeaker());

    // Give the speaker the items
    CreateItemOnObject("scepterofceledri", GetPCSpeaker(), 1);

}
