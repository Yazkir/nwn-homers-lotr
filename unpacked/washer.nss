//::///////////////////////////////////////////////
//:: FileName washer
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/2/2002 7:52:28 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    // Give the speaker some gold
    RewardPartyGP(75, GetPCSpeaker());
    object oTarget = GetPCSpeaker();
    effect eCharm = EffectCharmed();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, 20.0);

}
