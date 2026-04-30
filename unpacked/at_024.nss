//::///////////////////////////////////////////////
//:: FileName at_024
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/8/2002 1:42:54 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    // Give the speaker some XP
    RewardPartyXP(2000, GetPCSpeaker());

    // Give the speaker the items
    CreateItemOnObject("elrondswrit", GetPCSpeaker(), 1);

}
