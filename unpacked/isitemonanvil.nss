void ForgeLog(string sMsg)
{
    if (!GetLocalInt(GetModule(), "FORGE_DEBUG")) return;
    string sLine = "[FORGE] " + sMsg;
    WriteTimestampedLogEntry(sLine);
    SendMessageToAllDMs(sLine);
}

void SetTokens(object oItem)
{
    SetCustomToken(100, GetName(oItem));
    int iBase = GetBaseItemType(oItem);
    string sBase;
    switch ( iBase )
        {
        case BASE_ITEM_AMULET:
            sBase = "Amulet";
            break;
        case BASE_ITEM_ARMOR:
            sBase = "Armor";
            break;
        case BASE_ITEM_ARROW:
            sBase = "Arrow";
            break;
        case BASE_ITEM_BASTARDSWORD:
            sBase = "Sword";
            break;
        case BASE_ITEM_BATTLEAXE:
            sBase = "Axe";
            break;
        case BASE_ITEM_BELT:
            sBase = "Belt";
            break;
        case BASE_ITEM_BOLT:
            sBase = "Bolt";
            break;
        case BASE_ITEM_BOOTS:
            sBase = "Boots";
            break;
        case BASE_ITEM_BRACER:
            sBase = "Bracers";
            break;
        case BASE_ITEM_BULLET:
            sBase = "Bullet";
            break;
        case BASE_ITEM_CLOAK:
            sBase = "Cloak";
            break;
        case BASE_ITEM_CLUB:
            sBase = "Club";
            break;
        case BASE_ITEM_DAGGER:
            sBase = "Dagger";
            break;
        case BASE_ITEM_DART:
            sBase = "Dart";
            break;
        case BASE_ITEM_DIREMACE:
            sBase = "Dire Mace";
            break;
        case BASE_ITEM_DOUBLEAXE:
            sBase = "Double Axe";
            break;
        case BASE_ITEM_DWARVENWARAXE:
            sBase = "War Axe";
            break;
        case BASE_ITEM_GLOVES:
            sBase = "Gloves";
            break;
        case BASE_ITEM_GREATAXE:
            sBase = "Axe";
            break;
        case BASE_ITEM_GREATSWORD:
            sBase = "Sword";
            break;
        case BASE_ITEM_HALBERD:
            sBase = "Halberd";
            break;
        case BASE_ITEM_HANDAXE:
            sBase = "Axe";
            break;
        case BASE_ITEM_HEAVYCROSSBOW:
            sBase = "Crossbow";
            break;
        case BASE_ITEM_HEAVYFLAIL:
            sBase = "Flail";
            break;
        case BASE_ITEM_HELMET:
            sBase = "Helm";
            break;
        case BASE_ITEM_KAMA:
            sBase = "Kama";
            break;
        case BASE_ITEM_KATANA:
            sBase = "Katana";
            break;
        case BASE_ITEM_KUKRI:
            sBase = "Kukri";
            break;
        case BASE_ITEM_LARGESHIELD:
            sBase = "Shield";
            break;
        case BASE_ITEM_LIGHTCROSSBOW:
            sBase = "Crossbow";
            break;
        case BASE_ITEM_LIGHTFLAIL:
            sBase = "Flail";
            break;
        case BASE_ITEM_LIGHTHAMMER:
            sBase = "Hammer";
            break;
        case BASE_ITEM_LIGHTMACE:
            sBase = "Mace";
            break;
        case BASE_ITEM_LONGBOW:
            sBase = "Bow";
            break;
        case BASE_ITEM_LONGSWORD:
            sBase = "Sword";
            break;
        case BASE_ITEM_MAGICSTAFF:
            sBase = "Staff";
            break;
        case BASE_ITEM_MORNINGSTAR:
            sBase = "Morningstar";
            break;
        case BASE_ITEM_QUARTERSTAFF:
            sBase = "Staff";
            break;
        case BASE_ITEM_RAPIER:
            sBase = "Rapier";
            break;
        case BASE_ITEM_RING:
            sBase = "Ring";
            break;
        case BASE_ITEM_SCIMITAR:
            sBase = "Scimitar";
            break;
        case BASE_ITEM_SCYTHE:
            sBase = "Scythe";
            break;
        case BASE_ITEM_SHORTBOW:
            sBase = "Bow";
            break;
        case BASE_ITEM_SHORTSPEAR:
            sBase = "Spear";
            break;
        case BASE_ITEM_SHORTSWORD:
            sBase = "Sword";
            break;
        case BASE_ITEM_SHURIKEN:
            sBase = "Shuriken";
            break;
        case BASE_ITEM_SICKLE:
            sBase = "Sickle";
            break;
        case BASE_ITEM_SLING:
            sBase = "Sling";
            break;
        case BASE_ITEM_SMALLSHIELD:
            sBase = "Shield";
            break;
        case BASE_ITEM_THROWINGAXE:
            sBase = "Axe";
            break;
        case BASE_ITEM_TOWERSHIELD:
            sBase = "Shield";
            break;
        case BASE_ITEM_TWOBLADEDSWORD:
            sBase = "Sword";
            break;
        case BASE_ITEM_WARHAMMER:
            sBase = "Hammer";
            break;
        case BASE_ITEM_WHIP:
            sBase = "Whip";
            break;
        default:
            sBase = "Item";
            break;
        }
    SetCustomToken(102, sBase);
    SetCustomToken(103, GetName(GetPCSpeaker()));
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oAnvil = GetNearestObjectByTag("pAnvilOfWonder");
    if (oAnvil == OBJECT_INVALID)
    {
        ForgeLog("isitemonanvil: PC=" + GetName(oPC) + " anvil NOT FOUND — returning FALSE");
        return FALSE;
    }
    object oItem = GetFirstItemInInventory(oAnvil);
    if (oItem == OBJECT_INVALID)
    {
        ForgeLog("isitemonanvil: PC=" + GetName(oPC) + " anvil found but NO ITEM on it — returning FALSE");
        return FALSE;
    }
    object oNext = GetNextItemInInventory(oAnvil);
    if (oNext != OBJECT_INVALID)
    {
        ForgeLog("isitemonanvil: PC=" + GetName(oPC) + " MULTIPLE ITEMS on anvil — returning FALSE");
        return FALSE;
    }
    ForgeLog("isitemonanvil: PC=" + GetName(oPC) + " item='" + GetName(oItem) + "' value=" + IntToString(GetGoldPieceValue(oItem)) + " — returning TRUE");
    if (!GetLocalInt(oItem, "FORGE_BASE_SET"))
    {
        SetLocalInt(oItem, "FORGE_BASE_VALUE", GetGoldPieceValue(oItem));
        SetLocalInt(oItem, "FORGE_BASE_SET", TRUE);
    }
    SetLocalObject(oPC, "MODIFY_ITEM", oItem);
    // Per-forge value ceiling: read from the anvil's area (0 = uncapped).
    // FORGE_MAX_VALUE is set on each forge area's local vars (low 250k / mid 500k / high 750k).
    SetLocalInt(oPC, "MODIFY_MAX", GetLocalInt(GetArea(oAnvil), "FORGE_MAX_VALUE"));
    SetTokens(oItem);
    return TRUE;
}
