// Disenchant confirm: remove the picked permanent property from the target
// item. No gold changes hands — the magic is simply destroyed.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "FORGE_DIS_ITEM");
    int nPick = GetLocalInt(oPC, "FORGE_DIS_PICK");
    if (!GetIsObjectValid(oItem))
        return;
    itemproperty ip = ForgeGetPermPropByIndex(oItem, nPick);
    if (GetIsItemPropertyValid(ip))
    {
        ForgeLog("disenchant: PC=" + GetName(oPC) + " item='" + GetName(oItem)
            + "' removing [" + ForgePropName(ip) + "]");
        RemoveItemProperty(oItem, ip);
    }
    // Refresh the list tokens for the re-shown menu.
    ForgeDisenchantSetup(oPC, oItem);
}
