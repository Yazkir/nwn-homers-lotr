// Forge Warden accusation entry: name the offending item and prime the
// disenchant property list (shared forge_dis_* scripts work off these).
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oBad = ForgeFindIllegalItem(oPC);
    SetLocalObject(oPC, "FORGE_ILLEGAL_ITEM", oBad);
    // A stale success flag must not leak into the revert branch gate.
    DeleteLocalInt(oPC, "FORGE_RVT_OK");
    ForgeDisenchantSetup(oPC, oBad);
    SetCustomToken(6119, ForgeLegalStatus(oBad));
}
