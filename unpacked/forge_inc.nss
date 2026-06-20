// forge_inc.nss — shared helpers for the Forge of Wonders system.
//
// Pricing, per-forge caps, legality checks and the disenchant service all go
// through here. Do NOT #include "itemprocs" from this file (NWScript has no
// include guards; consumer scripts include both side by side).
//
// Reserved custom tokens: 6110-6117 disenchant slot names, 6118 picked name
// (forge already uses 100-103).

// Generated whitelist of legally-placed item variants (ForgeIsKnownLegalVariant,
// ForgeLegalFingerprint) — regenerate with bin/gen-forge-legal.py.
#include "forge_legal_inc"
// Appraise scaling (AppraiseBonusScaled) for the per-player value ceiling.
#include "appraise_inc"

const int FORGE_LEGAL_MAX_PROPS = 6;
const int FORGE_LEGAL_MAX_VALUE = 750000;

// Extra item value (gp) a maxed-Appraise player may lawfully forge above the
// default ceilings: +0 at no Appraise investment, +500,000 at an Appraise check
// of 65. Applied to each forge's per-tier cap, the global enchant backstop, and
// the contraband/jail ceiling alike. See appraise_inc.nss.
const int FORGE_APPRAISE_MAX_BONUS = 500000;

// Item-local int stamped by modifyitem when a forge lawfully enchants an item
// above the default global ceiling because the player's Appraise allowed it.
// Its value is the lawful per-item value ceiling that justified the work, so the
// contraband scan / Forge Warden honor it regardless of who later holds the item
// (legality stays intrinsic to the item — see FORGE_CLEAN note below).
const string FORGE_CEIL = "FORGE_CEIL";

// Appraise-extended value bonus for oPC (0..FORGE_APPRAISE_MAX_BONUS).
int ForgeAppraiseBonus(object oPC)
{
    return AppraiseBonusScaled(oPC, FORGE_APPRAISE_MAX_BONUS);
}
const string FORGE_VAULT_TAG = "FORGE_VAULT";
const int FORGE_DIS_SLOTS = 8;

// Contraband-scan "clean" stamp. An item verified legal by the login scan gets
// item-local int "FORGE_CLEAN" set to FORGE_CLEAN_VER; future logins skip it,
// so a repeat login does almost no work. The stamp persists with the item in
// the player's .bic. BUMP FORGE_CLEAN_VER whenever the legality rules or the
// forge_legal_inc whitelist change, so every item is re-scanned exactly once
// after a rules update. Forge masters clear the stamp when they modify an item
// (see modifyitem.nss / forge_dis_go.nss). Legality is intrinsic to the item,
// so a clean stamp is valid across owners — trading can't launder gear.
const int FORGE_CLEAN_VER = 2;

// Tri-state result of ForgeItemLegality.
const int FORGE_LEG_LEGAL         = 0;  // confirmed within the law
const int FORGE_LEG_ILLEGAL       = 1;  // tampered + over the ceiling
const int FORGE_LEG_INDETERMINATE = 2;  // valuation infra unavailable — don't judge

void ForgeLog(string sMsg)
{
    if (!GetLocalInt(GetModule(), "FORGE_DEBUG")) return;
    string sLine = "[FORGE] " + sMsg;
    WriteTimestampedLogEntry(sLine);
    SendMessageToAllDMs(sLine);
}

// Cosmetic properties are not enchantments: never counted, compared, listed
// or fingerprinted by the forge system. Covers weapon visual effects (Bree
// appearance station, see inc_emotewand AddItemPropertyVisualEffect) and
// Light of any color/brightness (Continual Flame, gems of power, the forge's
// own Light enchant — illumination only, no combat bonus). forge_legal_inc's
// ForgeLegalFingerprint mirrors this rule.
int ForgeIsCosmeticProp(itemproperty ip)
{
    int nType = GetItemPropertyType(ip);
    return nType == ITEM_PROPERTY_VISUALEFFECT
        || nType == ITEM_PROPERTY_LIGHT;
}

// Creature items (natural weapons / hide) are equipped by the engine into the
// creature slots during polymorph — druid Dragon Shape, wild shape, shifter
// forms, etc. They carry the form's built-in enchantments, have no stock
// blueprint, and cannot be forged or disenchanted by a player, so they must
// never count as contraband. Base item types 69-73 (CSLASHWEAPON, CPIERCWEAPON,
// CBLUDGWEAPON, CSLSHPRCWEAP, CREATUREITEM).
int ForgeIsCreatureItem(object oItem)
{
    int nBase = GetBaseItemType(oItem);
    return nBase == BASE_ITEM_CSLASHWEAPON
        || nBase == BASE_ITEM_CPIERCWEAPON
        || nBase == BASE_ITEM_CBLUDGWEAPON
        || nBase == BASE_ITEM_CSLSHPRCWEAP
        || nBase == BASE_ITEM_CREATUREITEM;
}

// Hidden inventory placeable (in the prison) used to host temporary item
// copies so valuations never transit a player-visible inventory or fire
// OnAcquireItem hooks. Falls back to OBJECT_SELF when it has an inventory.
object ForgeHolder()
{
    object oVault = GetObjectByTag(FORGE_VAULT_TAG);
    if (GetIsObjectValid(oVault))
        return oVault;
    if (GetHasInventory(OBJECT_SELF))
        return OBJECT_SELF;
    ForgeLog("ForgeHolder: FORGE_VAULT missing and OBJECT_SELF has no inventory");
    return OBJECT_INVALID;
}

// True assessed value of an item: priced as an identified, non-plot copy so
// unidentified/plot status can never discount an enchantment or dodge a cap.
// Returns -1 when no valuation is possible (callers must refuse, not treat
// as free).
// bPerUnit: value a single unit, not the whole stack. GetGoldPieceValue returns
// the stack's total, so the contraband ceiling (a per-item cap) must pass TRUE —
// otherwise a tall stack of cheap legal items reads as one over-cap item. The
// forge pricing callers leave it FALSE (enchanting a stack enchants every unit).
int ForgeItemValue(object oItem, int bPerUnit = FALSE)
{
    if (!GetIsObjectValid(oItem))
        return -1;
    object oHolder = ForgeHolder();
    if (!GetIsObjectValid(oHolder))
        return -1;
    object oCopy = CopyItem(oItem, oHolder, TRUE);
    if (!GetIsObjectValid(oCopy))
        return -1;
    if (bPerUnit)
        SetItemStackSize(oCopy, 1);
    SetIdentified(oCopy, TRUE);
    SetPlotFlag(oCopy, FALSE);
    int nValue = GetGoldPieceValue(oCopy);
    DestroyObject(oCopy);
    return nValue;
}

int ForgeCountProps(object oItem)
{
    int nCount = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT
            && !ForgeIsCosmeticProp(ip))
            nCount++;
        ip = GetNextItemProperty(oItem);
    }
    return nCount;
}

// Same matcher CustomAddProperty (itemprocs) uses to replace-instead-of-add:
// a property "matches" when types are equal and the new property's subtype is
// -1 (wildcard) or equal. A matching enchant replaces and does not grow the
// property count.
int ForgePropMatchesExisting(object oItem, itemproperty ip)
{
    int iTyp = GetItemPropertyType(ip);
    int iSubTyp = GetItemPropertySubType(ip);
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipLoop))
    {
        if (GetItemPropertyType(ipLoop) == iTyp
            && (iSubTyp == -1 || GetItemPropertySubType(ipLoop) == iSubTyp))
            return TRUE;
        ipLoop = GetNextItemProperty(oItem);
    }
    return FALSE;
}

// Nth (0-based) permanent property, in GetFirstItemProperty order.
itemproperty ForgeGetPermPropByIndex(object oItem, int nIndex)
{
    int nCount = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT
            && !ForgeIsCosmeticProp(ip))
        {
            if (nCount == nIndex)
                return ip;
            nCount++;
        }
        ip = GetNextItemProperty(oItem);
    }
    itemproperty ipInvalid;
    return ipInvalid;
}

// Human-readable property label from the 2das, e.g.
// "Enhancement Bonus: +3" or "Damage Bonus: Fire / 2d6".
// Falls back to raw numbers when a 2da lookup comes back empty.
string ForgePropName(itemproperty ip)
{
    int iTyp = GetItemPropertyType(ip);
    string sName;
    string sRef = Get2DAString("itempropdef", "GameStrRef", iTyp);
    if (sRef != "")
        sName = GetStringByStrRef(StringToInt(sRef));
    if (sName == "")
        sName = "Property #" + IntToString(iTyp);

    int iSubTyp = GetItemPropertySubType(ip);
    if (iSubTyp >= 0)
    {
        string sSubRes = Get2DAString("itempropdef", "SubTypeResRef", iTyp);
        if (sSubRes != "")
        {
            string sSubRef = Get2DAString(sSubRes, "Name", iSubTyp);
            string sSub = "";
            if (sSubRef != "")
                sSub = GetStringByStrRef(StringToInt(sSubRef));
            if (sSub == "")
                sSub = IntToString(iSubTyp);
            sName += ": " + sSub;
        }
    }

    int iCostTab = GetItemPropertyCostTable(ip);
    if (iCostTab >= 0)
    {
        string sCostRes = Get2DAString("iprp_costtable", "Name", iCostTab);
        if (sCostRes != "")
        {
            string sCostRef = Get2DAString(sCostRes, "Name",
                GetItemPropertyCostTableValue(ip));
            string sCost = "";
            if (sCostRef != "")
                sCost = GetStringByStrRef(StringToInt(sCostRef));
            if (sCost != "")
                sName += " " + sCost;
        }
    }
    return sName;
}

// Compare oItem's permanent properties against its pristine blueprint
// (instantiated by resref). Order-insensitive multiset compare keyed on
// (type, subtype, costtablevalue, param1value). Unknown resref counts as
// deviating — conservative by design.
int ForgeItemDeviatesFromBlueprint(object oItem)
{
    object oHolder = ForgeHolder();
    if (!GetIsObjectValid(oHolder))
        return FALSE; // can't judge — never jail on infrastructure failure

    string sResRef = GetResRef(oItem);
    object oStock = CreateItemOnObject(sResRef, oHolder);
    if (!GetIsObjectValid(oStock))
    {
        ForgeLog("DeviatesFromBlueprint: no blueprint for resref '" + sResRef
            + "' (item '" + GetName(oItem) + "') — treating as deviant");
        return TRUE;
    }

    int bDeviates = FALSE;
    if (ForgeCountProps(oItem) != ForgeCountProps(oStock))
        bDeviates = TRUE;
    else
    {
        // Every property on oItem must consume a distinct match on oStock.
        // Track consumed stock properties by index in a flag string.
        int nStock = ForgeCountProps(oStock);
        string sUsed; // one char per stock prop: "0" free, "1" consumed
        int i;
        for (i = 0; i < nStock; i++)
            sUsed += "0";

        itemproperty ip = GetFirstItemProperty(oItem);
        while (!bDeviates && GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT
                && !ForgeIsCosmeticProp(ip))
            {
                int bMatched = FALSE;
                for (i = 0; i < nStock && !bMatched; i++)
                {
                    if (GetSubString(sUsed, i, 1) == "0")
                    {
                        itemproperty ipS = ForgeGetPermPropByIndex(oStock, i);
                        if (GetItemPropertyType(ipS) == GetItemPropertyType(ip)
                            && GetItemPropertySubType(ipS) == GetItemPropertySubType(ip)
                            && GetItemPropertyCostTableValue(ipS) == GetItemPropertyCostTableValue(ip)
                            && GetItemPropertyParam1Value(ipS) == GetItemPropertyParam1Value(ip))
                        {
                            sUsed = GetStringLeft(sUsed, i) + "1"
                                + GetSubString(sUsed, i + 1, nStock - i - 1);
                            bMatched = TRUE;
                        }
                    }
                }
                if (!bMatched)
                    bDeviates = TRUE;
            }
            ip = GetNextItemProperty(oItem);
        }
    }
    DestroyObject(oStock);
    return bDeviates;
}

// Tri-state legality verdict. Illegal = exceeds the global legal ceiling
// (6 properties / 750,000 gp) AND was tampered with (deviates from its stock
// blueprint). Stock drops above the ceiling stay legal. Returns INDETERMINATE
// when no valuation is possible — callers must neither jail nor mark such items
// clean. The single source of truth for legality (ForgeIsItemIllegal and the
// login scan both go through here).
int ForgeItemLegality(object oItem)
{
    if (!GetIsObjectValid(oItem))
        return FORGE_LEG_LEGAL;
    if (ForgeIsCreatureItem(oItem))
        return FORGE_LEG_LEGAL; // polymorph natural weapon/hide — engine-managed, never forged
    int nValue = ForgeItemValue(oItem, TRUE); // per-unit: the cap is per item, not per stack
    if (nValue < 0)
        return FORGE_LEG_INDETERMINATE; // no valuation infrastructure — never judge blind
    // A forge stamps FORGE_CEIL on an item it lawfully enchanted above the
    // default ceiling because the forger's Appraise allowed it; honor that
    // higher per-item ceiling for everyone (legality is intrinsic to the item).
    int nValueCeil = FORGE_LEGAL_MAX_VALUE;
    int nStamp = GetLocalInt(oItem, FORGE_CEIL);
    if (nStamp > nValueCeil)
        nValueCeil = nStamp;
    if (ForgeCountProps(oItem) <= FORGE_LEGAL_MAX_PROPS
        && nValue <= nValueCeil)
        return FORGE_LEG_LEGAL;
    if (!ForgeItemDeviatesFromBlueprint(oItem))
        return FORGE_LEG_LEGAL;
    // Deviating from blueprint is fine when the deviation matches an item the
    // module itself places (embedded store stock, creature loot, container
    // contents) — those are legally obtainable, not player-forged.
    if (ForgeIsKnownLegalVariant(oItem))
    {
        ForgeLog("ItemLegality: '" + GetName(oItem) + "' (" + GetResRef(oItem)
            + ") deviates but matches a known legal variant — allowed.");
        return FORGE_LEG_LEGAL;
    }
    return FORGE_LEG_ILLEGAL;
}

int ForgeIsItemIllegal(object oItem)
{
    return ForgeItemLegality(oItem) == FORGE_LEG_ILLEGAL;
}

// TRUE when oItem exists and sits in oPC's inventory or equipment (one
// container level deep — bags can't nest). Guards warden scripts against
// stale cached handles whose object id the engine may have recycled.
int ForgePCHolds(object oPC, object oItem)
{
    if (!GetIsObjectValid(oItem))
        return FALSE;
    object oPoss = GetItemPossessor(oItem);
    if (oPoss == oPC)
        return TRUE;
    return GetIsObjectValid(oPoss) && GetItemPossessor(oPoss) == oPC;
}

// TRUE when oItem was already handled by the current revert-all pass on oPC
// (item-local FORGE_RVT_SKIP carries the pass's run stamp). Stale stamps from
// earlier passes don't match, so nothing is skipped forever.
int ForgeRevertSeen(object oItem, object oPC)
{
    return GetLocalInt(oItem, "FORGE_RVT_SKIP")
        == GetLocalInt(oPC, "FORGE_RVT_RUN");
}

// An item the login/Warden scan already verified legal carries the current
// FORGE_CLEAN stamp. Legality is intrinsic to the item and a forge clears the
// stamp on any change (see modifyitem / forge_dis_go), so a stamped item can be
// skipped without re-running the expensive valuation — this is what keeps the
// synchronous scanners (revert-all loop, release guard) under the instruction
// cap once an inventory has been scanned.
int ForgeIsKnownClean(object oItem)
{
    return GetLocalInt(oItem, "FORGE_CLEAN") == FORGE_CLEAN_VER;
}

// First illegal item on the PC: equipped slots, then inventory, descending
// one level into containers (bags can't nest in NWN). bSkipMarked skips items
// already handled by the current revert-all pass (see ForgeRevertSeen) — they
// still count as illegal everywhere else. Clean-stamped items are skipped before
// the costly legality check (short-circuit), so a fully-scanned inventory costs
// little here.
object ForgeFindIllegalItem(object oPC, int bSkipMarked = FALSE)
{
    int nSlot;
    for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
    {
        object oItem = GetItemInSlot(nSlot, oPC);
        if (GetIsObjectValid(oItem) && !ForgeIsKnownClean(oItem)
            && ForgeIsItemIllegal(oItem)
            && !(bSkipMarked && ForgeRevertSeen(oItem, oPC)))
            return oItem;
    }
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (!ForgeIsKnownClean(oItem) && ForgeIsItemIllegal(oItem)
            && !(bSkipMarked && ForgeRevertSeen(oItem, oPC)))
            return oItem;
        if (GetHasInventory(oItem))
        {
            object oInBag = GetFirstItemInInventory(oItem);
            while (GetIsObjectValid(oInBag))
            {
                if (!ForgeIsKnownClean(oInBag) && ForgeIsItemIllegal(oInBag)
                    && !(bSkipMarked && ForgeRevertSeen(oInBag, oPC)))
                    return oInBag;
                oInBag = GetNextItemInInventory(oItem);
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
    return OBJECT_INVALID;
}

// Replace oItem with a pristine copy of its stock blueprint, created on oPC.
// New item is created first so a missing blueprint never costs the player
// the original. Returns the new item, or OBJECT_INVALID when the blueprint
// is unknown (item left untouched). Equipped originals land the replacement
// in the backpack.
object ForgeRevertToBlueprint(object oItem, object oPC)
{
    if (!GetIsObjectValid(oItem))
        return OBJECT_INVALID;
    string sResRef = GetResRef(oItem);
    object oNew = CreateItemOnObject(sResRef, oPC);
    if (!GetIsObjectValid(oNew))
    {
        ForgeLog("RevertToBlueprint: no blueprint for resref '" + sResRef
            + "' (item '" + GetName(oItem) + "')");
        return OBJECT_INVALID;
    }
    SetIdentified(oNew, TRUE);
    ForgeLog("RevertToBlueprint: '" + GetName(oItem) + "' -> stock '"
        + GetName(oNew) + "' (resref " + sResRef + ") for " + GetName(oPC));
    DestroyObject(oItem);
    return oNew;
}

// Revert every illegal item on the PC to its stock blueprint. Returns how
// many could NOT be reverted (no known blueprint); those stay illegal.
// Every visited item is stamped with this pass's run id BEFORE the revert,
// so the loop terminates even if DestroyObject is deferred past the rescan.
int ForgeRevertAllIllegal(object oPC)
{
    int nRun = GetLocalInt(oPC, "FORGE_RVT_RUN") + 1;
    SetLocalInt(oPC, "FORGE_RVT_RUN", nRun);
    int nFail = 0;
    int nGuard = 0;
    object oBad = ForgeFindIllegalItem(oPC, TRUE);
    while (GetIsObjectValid(oBad) && nGuard < 100)
    {
        nGuard++;
        SetLocalInt(oBad, "FORGE_RVT_SKIP", nRun);
        if (!GetIsObjectValid(ForgeRevertToBlueprint(oBad, oPC)))
            nFail++;
        oBad = ForgeFindIllegalItem(oPC, TRUE);
    }
    return nFail;
}

// Player-facing summary of what still makes oItem unlawful (for the Forge
// Warden's dialog), or a confirmation that it is now within the law.
string ForgeLegalStatus(object oItem)
{
    if (!GetIsObjectValid(oItem))
        return "";
    int nProps = ForgeCountProps(oItem);
    int nValue = ForgeItemValue(oItem, TRUE); // per-unit: matches the ForgeIsItemIllegal gate
    // Honor any Appraise-extended ceiling stamped on the item (see FORGE_CEIL),
    // so a lawfully high-value piece reads as within the law, not contraband.
    int nValueCeil = FORGE_LEGAL_MAX_VALUE;
    int nStamp = GetLocalInt(oItem, FORGE_CEIL);
    if (nStamp > nValueCeil)
        nValueCeil = nStamp;
    int bProps = nProps > FORGE_LEGAL_MAX_PROPS;
    int bValue = nValue > nValueCeil;
    if (!bProps && !bValue)
        return "It is within the law now: " + IntToString(nProps)
            + " enchantments of the " + IntToString(FORGE_LEGAL_MAX_PROPS)
            + " allowed, and a worth of " + IntToString(nValue)
            + " gold under the lawful " + IntToString(nValueCeil) + ".";
    string s = "";
    if (bProps)
        s += "It still bears " + IntToString(nProps) + " enchantments where the "
            + "law allows but " + IntToString(FORGE_LEGAL_MAX_PROPS) + ".";
    if (bValue)
    {
        if (s != "") s += " And i";
        else s += "I";
        s += "ts worth, " + IntToString(nValue) + " gold, still exceeds the lawful "
            + IntToString(nValueCeil) + ".";
    }
    return s;
}

// Prime the disenchant sub-conversation: target item on the PC, property
// count, and one custom token per listed property slot.
void ForgeDisenchantSetup(object oPC, object oTarget)
{
    SetLocalObject(oPC, "FORGE_DIS_ITEM", oTarget);
    int nCount = 0;
    if (GetIsObjectValid(oTarget))
    {
        nCount = ForgeCountProps(oTarget);
        SetCustomToken(100, GetName(oTarget));
    }
    SetLocalInt(oPC, "FORGE_DIS_COUNT", nCount);
    int n;
    for (n = 0; n < FORGE_DIS_SLOTS; n++)
    {
        string sLabel = "";
        if (n < nCount)
            sLabel = ForgePropName(ForgeGetPermPropByIndex(oTarget, n));
        SetCustomToken(6110 + n, sLabel);
    }
}

// ---------------------------------------------------------------------------
// Staged (transactional) anvil disenchant. The forge masters let a player PLAN
// which properties to strike from an over-quality item and only commit the
// removals once the planned result would be lawful — so the real item never
// passes through an illegal state (and the player is never jailed mid-effort).
// A per-PC bitmask FORGE_STG_MASK records which ORIGINAL permanent-property
// indices are planned for removal; because nothing is mutated until commit, the
// indices stay stable for the whole conversation. These are ANVIL-ONLY — the
// Forge Warden's jail dialog keeps using the immediate-removal forge_dis_*
// scripts above.

// Effective per-item legality ceiling for oPC working oItem: the global cap
// raised by the player's live Appraise headroom, never below a FORGE_CEIL the
// item already carries. Mirrors the max() ForgeItemLegality uses, plus the live
// Appraise bonus (what this smith may allow this player).
int ForgeEffectiveCeil(object oPC, object oItem)
{
    int nCeil = FORGE_LEGAL_MAX_VALUE + ForgeAppraiseBonus(oPC);
    int nStamp = GetLocalInt(oItem, FORGE_CEIL);
    if (nStamp > nCeil)
        nCeil = nStamp;
    return nCeil;
}

// Projected per-unit value of oItem if every permanent-property index whose bit
// is set in nMask were removed. Works on a throwaway copy in FORGE_VAULT: copy,
// remove the staged props in DESCENDING index order (so the lower indices stay
// valid as we go), then price it identified/non-plot/per-unit exactly like
// ForgeItemValue. Returns -1 when valuation infrastructure is unavailable.
int ForgeProjectedValue(object oItem, int nMask)
{
    if (!GetIsObjectValid(oItem))
        return -1;
    object oHolder = ForgeHolder();
    if (!GetIsObjectValid(oHolder))
        return -1;
    object oCopy = CopyItem(oItem, oHolder, TRUE);
    if (!GetIsObjectValid(oCopy))
        return -1;
    int n;
    for (n = FORGE_DIS_SLOTS - 1; n >= 0; n--)
    {
        if (nMask & (1 << n))
        {
            itemproperty ip = ForgeGetPermPropByIndex(oCopy, n);
            if (GetIsItemPropertyValid(ip))
                RemoveItemProperty(oCopy, ip);
        }
    }
    SetItemStackSize(oCopy, 1);
    SetIdentified(oCopy, TRUE);
    SetPlotFlag(oCopy, FALSE);
    int nValue = GetGoldPieceValue(oCopy);
    DestroyObject(oCopy);
    return nValue;
}

// Permanent-property count remaining after the planned removals.
int ForgeProjectedPropCount(object oItem, int nMask)
{
    int nCount = ForgeCountProps(oItem);
    int nRemoved = 0;
    int n;
    for (n = 0; n < FORGE_DIS_SLOTS && n < nCount; n++)
        if (nMask & (1 << n))
            nRemoved++;
    return nCount - nRemoved;
}

// Player-facing running status of the planned result (header token 6119): the
// projected worth and whether it is within the law or how much it is still over.
string ForgeProjectedStatus(object oPC, object oItem, int nMask)
{
    if (!GetIsObjectValid(oItem))
        return "";
    int nVal = ForgeProjectedValue(oItem, nMask);
    if (nVal < 0)
        return "";
    int nCeil = ForgeEffectiveCeil(oPC, oItem);
    int nProps = ForgeProjectedPropCount(oItem, nMask);
    string s;
    if (nMask == 0)
        s = "As it stands the " + GetName(oItem) + " is worth "
            + IntToString(nVal) + " gold";
    else
        s = "With your plan struck, the " + GetName(oItem) + " would be worth "
            + IntToString(nVal) + " gold";
    if (nVal <= nCeil && nProps <= FORGE_LEGAL_MAX_PROPS)
        return s + " — within the lawful " + IntToString(nCeil) + ".";
    if (nVal > nCeil)
        s += ", still " + IntToString(nVal - nCeil) + " over the lawful "
            + IntToString(nCeil);
    if (nProps > FORGE_LEGAL_MAX_PROPS)
        s += ", and bears " + IntToString(nProps) + " enchantments where the law "
            + "allows but " + IntToString(FORGE_LEGAL_MAX_PROPS);
    return s + ". Strike more to bring it within the law.";
}

// TRUE when the plan is non-empty AND the projected result is lawful (worth
// within ForgeEffectiveCeil and at most FORGE_LEGAL_MAX_PROPS properties).
// Drives the commit reply's Active gate (forge_stg_ok).
int ForgeStagePlanIsLawful(object oPC, object oItem, int nMask)
{
    if (nMask == 0 || !GetIsObjectValid(oItem))
        return FALSE;
    int nVal = ForgeProjectedValue(oItem, nMask);
    if (nVal < 0)
        return FALSE;
    if (nVal > ForgeEffectiveCeil(oPC, oItem))
        return FALSE;
    return ForgeProjectedPropCount(oItem, nMask) <= FORGE_LEGAL_MAX_PROPS;
}

// Prime the staged anvil disenchant menu: target item, property count, name
// token 100, per-slot label+cue tokens 6110-6117 (each marked planned/kept with
// the worth that CLICKING it would produce), and the running status token 6119.
void ForgeStageSetupCued(object oPC, object oItem)
{
    SetLocalObject(oPC, "FORGE_STG_ITEM", oItem);
    int nCount = 0;
    if (GetIsObjectValid(oItem))
    {
        nCount = ForgeCountProps(oItem);
        SetCustomToken(100, GetName(oItem));
    }
    SetLocalInt(oPC, "FORGE_DIS_COUNT", nCount);
    int nMask = GetLocalInt(oPC, "FORGE_STG_MASK");
    int nCeil = GetIsObjectValid(oItem) ? ForgeEffectiveCeil(oPC, oItem) : 0;
    int n;
    for (n = 0; n < FORGE_DIS_SLOTS; n++)
    {
        string sLabel = "";
        if (n < nCount)
        {
            int bStaged = (nMask & (1 << n)) != 0;
            string sName = ForgePropName(ForgeGetPermPropByIndex(oItem, n));
            // Worth the item would have if the player CLICKS this slot (toggles
            // its plan bit): striking an unplanned prop, or keeping a planned one.
            int nVal = ForgeProjectedValue(oItem, nMask ^ (1 << n));
            string sCue = "";
            if (nVal >= 0)
            {
                string sVerb = bStaged ? "keep" : "strike";
                if (nVal <= nCeil)
                    sCue = "  (" + sVerb + " -> " + IntToString(nVal)
                        + " gp: lawful)";
                else
                    sCue = "  (" + sVerb + " -> " + IntToString(nVal) + " gp: "
                        + IntToString(nVal - nCeil) + " over)";
            }
            sLabel = (bStaged ? "[planned] " : "") + sName + sCue;
        }
        SetCustomToken(6110 + n, sLabel);
    }
    SetCustomToken(6119, ForgeProjectedStatus(oPC, oItem, nMask));
}

// Stamp the lawful ceiling and clean mark on a freshly-worked item so legality
// is intrinsic and the login/Well contraband scan agrees in O(1). Per the user
// request the ceiling (with Appraise headroom) is recorded whenever the smith
// works the item, so it stays lawful even if the bearer later loses Appraise or
// trades the item away. Mirrors the FORGE_CEIL/FORGE_CLEAN contract in
// modifyitem.nss.
void ForgeStampLawful(object oPC, object oItem)
{
    if (!GetIsObjectValid(oItem))
        return;
    int nCeil = FORGE_LEGAL_MAX_VALUE + ForgeAppraiseBonus(oPC);
    if (nCeil > GetLocalInt(oItem, FORGE_CEIL))
        SetLocalInt(oItem, FORGE_CEIL, nCeil);
    if (ForgeItemLegality(oItem) == FORGE_LEG_LEGAL)
        SetLocalInt(oItem, "FORGE_CLEAN", FORGE_CLEAN_VER);
}

// Commit the plan: strike every planned property from the REAL item (highest
// index first so lower indices stay valid), then stamp it lawful and clear the
// plan. Called only from forge_stg_go, whose reply is gated by ForgeStagePlanIsLawful.
void ForgeStageCommit(object oPC, object oItem)
{
    if (!GetIsObjectValid(oItem))
        return;
    int nMask = GetLocalInt(oPC, "FORGE_STG_MASK");
    int n;
    for (n = FORGE_DIS_SLOTS - 1; n >= 0; n--)
    {
        if (nMask & (1 << n))
        {
            itemproperty ip = ForgeGetPermPropByIndex(oItem, n);
            if (GetIsItemPropertyValid(ip))
            {
                ForgeLog("stage-disenchant: PC=" + GetName(oPC) + " item='"
                    + GetName(oItem) + "' removing [" + ForgePropName(ip) + "]");
                RemoveItemProperty(oItem, ip);
            }
        }
    }
    // Footprint changed — drop the stale clean stamp, then re-stamp the lawful
    // ceiling + clean mark on the now-lawful result.
    DeleteLocalInt(oItem, "FORGE_CLEAN");
    ForgeStampLawful(oPC, oItem);
    DeleteLocalInt(oPC, "FORGE_STG_MASK");
}

// Sequester a contested item for DM review: stored in the craftdb quarantine
// queue (same keys welloferuenter.nss uses), so it lands in the DM-review
// chest (ZEP_CR_QUARANTINE, House of Homer) on next open. No refund — a DM
// returns the item if the player's claim holds.
void ForgeQuarantineDisputedItem(object oItem, object oPC)
{
    if (!GetIsObjectValid(oItem) || !GetIsObjectValid(oPC))
        return;
    string sName = GetName(oItem);
    // Value the item BEFORE StoreCampaignObject/DestroyObject invalidate it.
    string sLog = "[FORGE DISPUTE] Item '" + sName + "' (resref: "
        + GetResRef(oItem) + ", props " + IntToString(ForgeCountProps(oItem))
        + ", value " + IntToString(ForgeItemValue(oItem))
        + ") sequestered from " + GetName(oPC) + " (account: "
        + GetPCPlayerName(oPC) + ") pending DM review.";

    // Stamp provenance onto the item itself so it travels with the object into
    // the quarantine chest snapshot and survives until a DM physically removes
    // it from the chest. The parallel quarantine_*_info campaign string below
    // is cleared the moment the chest is first opened (zep_cr_qrestore.nss), so
    // this local var is the durable record of who submitted the item.
    SetLocalString(oItem, "QUARANTINE_INFO", sLog);

    int nQ = GetCampaignInt("craftdb", "quarantine_count");
    StoreCampaignObject("craftdb", "quarantine_" + IntToString(nQ), oItem);
    SetCampaignString("craftdb", "quarantine_" + IntToString(nQ) + "_info", sLog);
    SetCampaignInt("craftdb", "quarantine_count", nQ + 1);
    DestroyObject(oItem);

    WriteTimestampedLogEntry(sLog);
    SendMessageToAllDMs(sLog);
    SendMessageToPC(oPC, "[Forge Warden] Your '" + sName + "' has been "
        + "sequestered under seal in the House of Homer pending DM review. "
        + "If your claim of lawful provenance holds, it will be returned to "
        + "you; if not, it is forfeit. No compensation is owed while the "
        + "matter is under judgment.");
}

// Jail oPC in the Pit Prison for carrying the illegal item oBad. Shared by the
// synchronous ForgeJailIfIllegal and the chunked login scan (forge_scan_step).
void ForgeJailForItem(object oPC, object oBad)
{
    if (!GetIsObjectValid(oBad))
        return;
    SetLocalObject(oPC, "FORGE_ILLEGAL_ITEM", oBad);
    // Seed the Warden's O(1) gate verdict: the scan just proved this item
    // illegal, so the gates can trust "dirty" the moment the PC arrives, with
    // no need to re-scan a (possibly huge) inventory inside a StartingConditional.
    SetLocalInt(oPC, "FORGE_WARDEN_DIRTY", TRUE);
    SetLocalInt(oPC, "FORGE_WARDEN_READY", TRUE);
    ForgeLog("Jailing " + GetName(oPC) + " for item '" + GetName(oBad)
        + "' (resref " + GetResRef(oBad) + ", props "
        + IntToString(ForgeCountProps(oBad)) + ", value "
        + IntToString(ForgeItemValue(oBad)) + ", fp="
        + ForgeLegalFingerprint(oBad) + ")");
    object oWP = GetWaypointByTag("jailed");
    if (!GetIsObjectValid(oWP))
    {
        ForgeLog("ForgeJailForItem: waypoint 'jailed' missing!");
        return;
    }
    FloatingTextStringOnCreature("The " + GetName(oBad) + " you carry bears "
        + "unlawful enchantment. The Valar take notice...", oPC, FALSE);
    location lJail = GetLocation(oWP);
    DelayCommand(1.0, AssignCommand(oPC, JumpToLocation(lJail)));
    // Spoken hint after arrival so the player knows which jailer applies.
    DelayCommand(3.0, AssignCommand(oPC, SpeakString("The forged enchantments "
        + "on my " + GetName(oBad) + " are beyond the law. I should speak with "
        + "a FORGE WARDEN to make my gear lawful again.")));
}

// Jail the PC in the Pit Prison if they carry illegally forged gear. Synchronous
// full scan — kept for callers that need an immediate verdict; the login path
// uses ForgeBeginScan instead to stay under the instruction cap.
void ForgeJailIfIllegal(object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;
    ForgeJailForItem(oPC, ForgeFindIllegalItem(oPC));
}

// Enumerate oPC's equipment, then inventory and one level of bag contents into
// ordered item-handle locals (FORGE_SCAN_0..N-1, count FORGE_SCAN_N, cursor
// FORGE_SCAN_I reset to 0). Returns the item count. This pass does no
// valuation/blueprint work, so it is cheap even for a large inventory; the
// per-item cost is paid one item at a time by forge_scan_step. Shared by the
// login (jail) scan and the Warden (verdict) scan.
int ForgeEnqueueScan(object oPC)
{
    int n = 0;
    int nSlot;
    for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
    {
        object oItem = GetItemInSlot(nSlot, oPC);
        if (GetIsObjectValid(oItem))
            SetLocalObject(oPC, "FORGE_SCAN_" + IntToString(n++), oItem);
    }
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        SetLocalObject(oPC, "FORGE_SCAN_" + IntToString(n++), oItem);
        if (GetHasInventory(oItem))
        {
            object oInBag = GetFirstItemInInventory(oItem);
            while (GetIsObjectValid(oInBag))
            {
                SetLocalObject(oPC, "FORGE_SCAN_" + IntToString(n++), oInBag);
                oInBag = GetNextItemInInventory(oItem);
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
    SetLocalInt(oPC, "FORGE_SCAN_N", n);
    SetLocalInt(oPC, "FORGE_SCAN_I", 0);
    return n;
}

// Begin a chunked contraband scan of oPC in LOGIN mode: forge_scan_step
// evaluates ONE item per delayed step — each step gets a fresh NWScript
// instruction budget, so a full inventory can't overflow — and jails the bearer
// on the first illegal item.
void ForgeBeginScan(object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;
    SetLocalInt(oPC, "FORGE_SCAN_MODE", 0); // login/jail mode
    int n = ForgeEnqueueScan(oPC);
    if (n > 0)
        DelayCommand(0.1, ExecuteScript("forge_scan_step", oPC));
}

// Begin a chunked scan of oPC in WARDEN VERDICT mode: forge_scan_step records
// the contraband verdict into FORGE_WARDEN_DIRTY / FORGE_WARDEN_READY (and
// FORGE_ILLEGAL_ITEM) WITHOUT jailing, so the Forge Warden's dialog gates
// (forge_ward_c_il / forge_ward_c_ok) can read an O(1) cached result instead of
// scanning a whole inventory inside a StartingConditional (the cause of the
// TOO MANY INSTRUCTIONS prison trap). Refreshed on each mutating Warden action.
void ForgeBeginWardenScan(object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;
    SetLocalInt(oPC, "FORGE_SCAN_MODE", 1); // warden verdict mode
    SetLocalInt(oPC, "FORGE_WARDEN_READY", FALSE); // verdict pending until scan ends
    int n = ForgeEnqueueScan(oPC);
    if (n > 0)
    {
        DelayCommand(0.1, ExecuteScript("forge_scan_step", oPC));
        return;
    }
    // Empty inventory: trivially clean, verdict known immediately.
    SetLocalInt(oPC, "FORGE_WARDEN_DIRTY", FALSE);
    DeleteLocalObject(oPC, "FORGE_ILLEGAL_ITEM");
    SetLocalInt(oPC, "FORGE_WARDEN_READY", TRUE);
}
