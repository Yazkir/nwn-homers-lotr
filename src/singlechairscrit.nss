#include "nw_i0_tool"
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

RewardPartyXP(2000, oPC, FALSE);

}

