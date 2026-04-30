//::///////////////////////////////////////////////
//:: FileName at_071
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/11/2002 10:58:05 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
	// Give the speaker some gold
	RewardPartyGP(200, GetPCSpeaker());

	// Give the speaker some XP
	RewardPartyXP(250, GetPCSpeaker());

	// Give the speaker the items
	CreateItemOnObject("ringofwoe", GetPCSpeaker(), 1);

}
