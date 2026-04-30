//::///////////////////////////////////////////////
//:: FileName at_041
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/13/2002 12:48:13 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    // Give the speaker some XP
    RewardPartyXP(1500, GetPCSpeaker());
object Rescuer = GetObjectByTag("erk3");
SignalEvent(Rescuer, EventUserDefined(555));




}
