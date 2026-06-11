// Forge Warden gate: TRUE when the item under the warden's hammer
// (FORGE_DIS_ITEM) has become lawful — stop offering further removals.
#include "forge_inc"

int StartingConditional()
{
    object oItem = GetLocalObject(GetPCSpeaker(), "FORGE_DIS_ITEM");
    return GetIsObjectValid(oItem) && !ForgeIsItemIllegal(oItem);
}
