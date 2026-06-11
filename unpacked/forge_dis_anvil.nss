// Disenchant menu entry script (anvil context): prime the property list
// tokens (6110-6117) for the item on the anvil.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    ForgeDisenchantSetup(oPC, GetLocalObject(oPC, "MODIFY_ITEM"));
}
