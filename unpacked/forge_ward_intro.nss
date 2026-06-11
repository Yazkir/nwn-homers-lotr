// Forge Warden accusation entry: name the offending item and prime the
// disenchant property list (shared forge_dis_* scripts work off these).
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oBad = ForgeFindIllegalItem(oPC);
    SetLocalObject(oPC, "FORGE_ILLEGAL_ITEM", oBad);
    ForgeDisenchantSetup(oPC, oBad);
    SetCustomToken(6119, ForgeLegalStatus(oBad));
}
