// Forge Warden dispute action: the PC contests the legality of the flagged
// item, so sequester it for DM review in the ZEP_CR_QUARANTINE chest (House
// of Homer) via ForgeQuarantineDisputedItem. No refund — a DM returns the
// item if the claim holds. The conversation gates re-scan afterwards, so a
// now-clean PC can ask for release as usual.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "FORGE_ILLEGAL_ITEM");
    if (!GetIsObjectValid(oItem))
        oItem = ForgeFindIllegalItem(oPC); // belt and braces
    if (!GetIsObjectValid(oItem))
        return;
    ForgeQuarantineDisputedItem(oItem, oPC);
    DeleteLocalObject(oPC, "FORGE_ILLEGAL_ITEM");
}
