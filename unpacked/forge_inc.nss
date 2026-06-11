// forge_inc.nss — shared helpers for the Forge of Wonders system.
//
// Pricing, per-forge caps, legality checks and the disenchant service all go
// through here. Do NOT #include "itemprocs" from this file (NWScript has no
// include guards; consumer scripts include both side by side).
//
// Reserved custom tokens: 6110-6117 disenchant slot names, 6118 picked name
// (forge already uses 100-103).

const int FORGE_LEGAL_MAX_PROPS = 6;
const int FORGE_LEGAL_MAX_VALUE = 750000;
const string FORGE_VAULT_TAG = "FORGE_VAULT";
const int FORGE_DIS_SLOTS = 8;

void ForgeLog(string sMsg)
{
    if (!GetLocalInt(GetModule(), "FORGE_DEBUG")) return;
    string sLine = "[FORGE] " + sMsg;
    WriteTimestampedLogEntry(sLine);
    SendMessageToAllDMs(sLine);
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
int ForgeItemValue(object oItem)
{
    if (!GetIsObjectValid(oItem))
        return -1;
    object oHolder = ForgeHolder();
    if (!GetIsObjectValid(oHolder))
        return -1;
    object oCopy = CopyItem(oItem, oHolder, TRUE);
    if (!GetIsObjectValid(oCopy))
        return -1;
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
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
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
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
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
            if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
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

// Illegal = exceeds the global legal ceiling (6 properties / 750,000 gp)
// AND was tampered with (deviates from its stock blueprint). Stock drops
// above the ceiling stay legal.
int ForgeIsItemIllegal(object oItem)
{
    if (!GetIsObjectValid(oItem))
        return FALSE;
    int nValue = ForgeItemValue(oItem);
    if (ForgeCountProps(oItem) <= FORGE_LEGAL_MAX_PROPS
        && nValue >= 0 && nValue <= FORGE_LEGAL_MAX_VALUE)
        return FALSE;
    if (nValue < 0)
        return FALSE; // no valuation infrastructure — never jail blind
    return ForgeItemDeviatesFromBlueprint(oItem);
}

// First illegal item on the PC: equipped slots, then inventory, descending
// one level into containers (bags can't nest in NWN).
object ForgeFindIllegalItem(object oPC)
{
    int nSlot;
    for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
    {
        object oItem = GetItemInSlot(nSlot, oPC);
        if (GetIsObjectValid(oItem) && ForgeIsItemIllegal(oItem))
            return oItem;
    }
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (ForgeIsItemIllegal(oItem))
            return oItem;
        if (GetHasInventory(oItem))
        {
            object oInBag = GetFirstItemInInventory(oItem);
            while (GetIsObjectValid(oInBag))
            {
                if (ForgeIsItemIllegal(oInBag))
                    return oInBag;
                oInBag = GetNextItemInInventory(oItem);
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
    return OBJECT_INVALID;
}

// Player-facing summary of what still makes oItem unlawful (for the Forge
// Warden's dialog), or a confirmation that it is now within the law.
string ForgeLegalStatus(object oItem)
{
    if (!GetIsObjectValid(oItem))
        return "";
    int nProps = ForgeCountProps(oItem);
    int nValue = ForgeItemValue(oItem);
    int bProps = nProps > FORGE_LEGAL_MAX_PROPS;
    int bValue = nValue > FORGE_LEGAL_MAX_VALUE;
    if (!bProps && !bValue)
        return "It is within the law now: " + IntToString(nProps)
            + " enchantments of the " + IntToString(FORGE_LEGAL_MAX_PROPS)
            + " allowed, and a worth of " + IntToString(nValue)
            + " gold under the lawful " + IntToString(FORGE_LEGAL_MAX_VALUE) + ".";
    string s = "";
    if (bProps)
        s += "It still bears " + IntToString(nProps) + " enchantments where the "
            + "law allows but " + IntToString(FORGE_LEGAL_MAX_PROPS) + ".";
    if (bValue)
    {
        if (s != "") s += " And i";
        else s += "I";
        s += "ts worth, " + IntToString(nValue) + " gold, still exceeds the lawful "
            + IntToString(FORGE_LEGAL_MAX_VALUE) + ".";
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

// Jail the PC in the Pit Prison if they carry illegally forged gear.
void ForgeJailIfIllegal(object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;
    object oBad = ForgeFindIllegalItem(oPC);
    if (!GetIsObjectValid(oBad))
        return;
    SetLocalObject(oPC, "FORGE_ILLEGAL_ITEM", oBad);
    ForgeLog("Jailing " + GetName(oPC) + " for item '" + GetName(oBad)
        + "' (resref " + GetResRef(oBad) + ", props "
        + IntToString(ForgeCountProps(oBad)) + ", value "
        + IntToString(ForgeItemValue(oBad)) + ")");
    object oWP = GetWaypointByTag("jailed");
    if (!GetIsObjectValid(oWP))
    {
        ForgeLog("ForgeJailIfIllegal: waypoint 'jailed' missing!");
        return;
    }
    FloatingTextStringOnCreature("The " + GetName(oBad) + " you carry bears "
        + "unlawful enchantment. The Valar take notice...", oPC, FALSE);
    location lJail = GetLocation(oWP);
    DelayCommand(1.0, AssignCommand(oPC, JumpToLocation(lJail)));
    // Spoken hint after arrival so the player knows which jailer applies.
    DelayCommand(3.0, AssignCommand(oPC, SpeakString("The forged enchantments "
        + "on my " + GetName(oBad) + " are beyond the law. I should speak with "
        + "the FORGE WARDEN to make my gear lawful again.")));
}
