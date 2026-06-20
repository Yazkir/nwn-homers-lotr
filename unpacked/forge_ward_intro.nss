// Forge Warden accusation entry: name the offending item and prime the
// disenchant property list (shared forge_dis_* scripts work off these).
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    // Name the offending item from the cached verdict (set by the jail scan or a
    // prior Warden scan) instead of re-scanning the whole inventory here — the
    // synchronous scan is the instruction-cap hazard we are eliminating. Fall
    // back to one scan only if nothing is cached yet.
    object oBad = GetLocalObject(oPC, "FORGE_ILLEGAL_ITEM");
    if (!ForgePCHolds(oPC, oBad) || !ForgeIsItemIllegal(oBad))
        oBad = ForgeFindIllegalItem(oPC);
    SetLocalObject(oPC, "FORGE_ILLEGAL_ITEM", oBad);
    // A stale success flag must not leak into the revert branch gate.
    DeleteLocalInt(oPC, "FORGE_RVT_OK");
    ForgeDisenchantSetup(oPC, oBad);
    SetCustomToken(6119, ForgeLegalStatus(oBad));
    // Refresh the cached gate verdict off the hot path so manual changes since
    // the PC was jailed (e.g. dropping the item) are reflected on the next click.
    ForgeBeginWardenScan(oPC);
}
