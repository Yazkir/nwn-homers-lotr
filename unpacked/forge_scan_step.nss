// forge_scan_step — one step of the chunked contraband login scan.
//
// Run via ExecuteScript on the PC (OBJECT_SELF = the player) from
// ForgeBeginScan (forge_inc). Evaluates the single queued item at the cursor,
// then reschedules itself for the next item. Processing one item per delayed
// action keeps every step well under the NWScript instruction cap, so a full
// inventory of high-end gear can no longer blow up the login enter scripts.
//
// Items confirmed legal are stamped FORGE_CLEAN = FORGE_CLEAN_VER so later
// logins skip them. An illegal item jails the bearer and stops the scan.
// INDETERMINATE items (valuation infrastructure unavailable) are left unstamped
// to be re-checked next login.

#include "forge_inc"

void main()
{
    object oPC = OBJECT_SELF;

    int nN = GetLocalInt(oPC, "FORGE_SCAN_N");
    int i  = GetLocalInt(oPC, "FORGE_SCAN_I");
    if (i >= nN)
        return; // queue drained (or scan superseded)

    string sKey = "FORGE_SCAN_" + IntToString(i);
    object oItem = GetLocalObject(oPC, sKey);
    DeleteLocalObject(oPC, sKey);
    SetLocalInt(oPC, "FORGE_SCAN_I", i + 1);

    if (GetIsObjectValid(oItem)
        && GetLocalInt(oItem, "FORGE_CLEAN") != FORGE_CLEAN_VER)
    {
        int nVerdict = ForgeItemLegality(oItem);
        if (nVerdict == FORGE_LEG_ILLEGAL)
        {
            ForgeJailForItem(oPC, oItem);
            return; // stop scanning — bearer is being jailed
        }
        if (nVerdict == FORGE_LEG_LEGAL)
            SetLocalInt(oItem, "FORGE_CLEAN", FORGE_CLEAN_VER);
        // INDETERMINATE: leave unstamped, re-evaluate next login.
    }

    if (i + 1 < nN)
        DelayCommand(0.1, ExecuteScript("forge_scan_step", oPC));
}
