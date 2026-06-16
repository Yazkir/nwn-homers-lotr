// store_appr_inc.nss — Appraise-scaled, per-PC store opening.
//
// A store's MaxBuyPrice (the cap on the gold it will pay a player for any one
// item) lives on the shared store object, so scaling it in place would leak one
// player's Appraise bonus to everyone else shopping the same store. Instead,
// OpenStoreAppr opens a throwaway COPY of the store whose cap is scaled by the
// opening player's Appraise — fully per-player, nothing shared. The copy is
// destroyed when the player closes it (store_appr_cls on STORE_ON_CLOSE), with
// a delayed fallback in case the close event is missed.
//
// Use this in place of OpenStore(...) / gplotAppraiseOpenStore(...) in the
// conversation/opener scripts of stores that BUY from players. The only added
// effect is the Appraise-scaled buy cap on capped stores; the store is otherwise
// opened exactly as before. bAppraisePricing mirrors how the original opener
// opened the store, so existing buy/sell pricing is preserved:
//   - openers that used plain OpenStore  -> OpenStoreAppr(oStore, oPC)        (FALSE)
//   - openers that used gplotAppraiseOpenStore -> OpenStoreAppr(o, oPC, TRUE) (gplot)
// Uncapped stores (MaxBuyPrice -1) open normally with no copy.

#include "appraise_inc"
#include "nw_i0_plot"   // gplotAppraiseOpenStore — preserves stock store pricing

// Open oStore for oPC using whichever stock open call the original opener used.
void StoreOpenAs(object oStore, object oPC, int bAppraisePricing)
{
    if (bAppraisePricing)
        gplotAppraiseOpenStore(oStore, oPC);
    else
        OpenStore(oStore, oPC);
}

void OpenStoreAppr(object oStore, object oPC, int bAppraisePricing = FALSE)
{
    if (GetObjectType(oStore) != OBJECT_TYPE_STORE || !GetIsPC(oPC))
        return;

    int nBase = GetStoreMaxBuyPrice(oStore);
    // -1 = uncapped: nothing to raise, open the real store directly.
    if (nBase <= 0)
    {
        StoreOpenAs(oStore, oPC, bAppraisePricing);
        return;
    }

    // Per-PC throwaway copy. bCopyLocalState=TRUE carries the live store's
    // inventory, local vars and event scripts (e.g. clean_store2 OnOpen).
    object oCopy = CopyObject(oStore, GetLocation(oStore), OBJECT_INVALID, "", TRUE);
    if (!GetIsObjectValid(oCopy))
    {
        // Copy failed — never deny the player their store; open the original.
        StoreOpenAs(oStore, oPC, bAppraisePricing);
        return;
    }

    // Raise this player's cap: +0 with no Appraise investment, up to +100%
    // (double) at an Appraise check of 65.
    SetStoreMaxBuyPrice(oCopy, nBase + AppraiseBonusScaled(oPC, nBase));
    SetLocalInt(oCopy, "STORE_APPR_COPY", TRUE);
    SetEventScript(oCopy, EVENT_SCRIPT_STORE_ON_CLOSE, "store_appr_cls");
    StoreOpenAs(oCopy, oPC, bAppraisePricing);
    // Fallback cleanup if the close event never fires (e.g. client disconnect).
    DestroyObject(oCopy, 1800.0);
}
