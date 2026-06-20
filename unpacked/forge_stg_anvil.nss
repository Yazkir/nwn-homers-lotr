// Staged anvil disenchant menu entry: prime the property list, per-slot cues
// (tokens 6110-6117) and the running status header (token 6119) for the item on
// the anvil. Starts each visit with an empty plan so a re-opened menu is fresh.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    // Fresh plan whenever the menu is opened on a different item than last time.
    if (oItem != GetLocalObject(oPC, "FORGE_STG_ITEM"))
        DeleteLocalInt(oPC, "FORGE_STG_MASK");
    ForgeStageSetupCued(oPC, oItem);
}
