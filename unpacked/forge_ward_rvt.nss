// Forge Warden: revert the item under the hammer (FORGE_DIS_ITEM) to its
// stock blueprint. Sets FORGE_RVT_OK so the dialog can branch on success.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "FORGE_DIS_ITEM");
    object oNew = ForgeRevertToBlueprint(oItem, oPC);
    if (GetIsObjectValid(oNew))
    {
        SetLocalInt(oPC, "FORGE_RVT_OK", TRUE);
        SetLocalObject(oPC, "FORGE_ILLEGAL_ITEM", oNew);
        ForgeDisenchantSetup(oPC, oNew);
        SetCustomToken(6119, ForgeLegalStatus(oNew));
    }
    else
        SetLocalInt(oPC, "FORGE_RVT_OK", FALSE);
}
