// Forge Warden disenchant menu entry script: target the confiscation-flagged
// item (set by forge_ward_intro) rather than an anvil item.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    ForgeDisenchantSetup(oPC, GetLocalObject(oPC, "FORGE_ILLEGAL_ITEM"));
}
