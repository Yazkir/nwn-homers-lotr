//Can go OnDamaged, OnDisturbed, OnSpellCastAt, creature heartbeats, etc.
#include "nw_i0_tool"
void main()
{

object oPC = GetLastHostileActor();

if (!GetIsPC(oPC)) return;

RewardPartyXP(50000, oPC, FALSE);

}

