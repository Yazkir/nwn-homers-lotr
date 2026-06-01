// Well of Eru OnEnter
// - Sends a welcome message and gives 3000 starter XP to brand-new characters.
// - Stocks the Donations Chest once per server reset with:
//     * Loot from a randomly selected good-side city (Guardian of Light list)
//     * Loot from a randomly selected evil-side city (Guardian of Darkness list)
//     * Two random bonus items drawn from the obtainable custom item pool

// Creates an item and immediately identifies it.
object CreateIDItem(string sResRef, object oTarget, int nStackSize = 1)
{
    object oItem = CreateItemOnObject(sResRef, oTarget, nStackSize);
    SetIdentified(oItem, TRUE);
    return oItem;
}

// --- bonus item pool: 90 obtainable custom items (accessible via stores/containers/drops) ---
// Returns 99 for ammunition cases, 1 for everything else.
int GetBonusItemStackSize(int n)
{
    switch (n)
    {
        case 3:  // greaterfirearrow
        case 15: // 043 Arrow of the Orc Defender
        case 16: // 044 Arrow of the Orc Defender
        case 45: // elitebolt
        case 58: // wammar051 Arwen's Arrow
        case 68: // wammar050 Angmar's Piercing Arrow
            return 99;
    }
    return 1;
}

string GetBonusItemResref(int n)
{
    switch (n)
    {
        case 0:  return "gwathdorhelme002";   // Gwathdor Helmet
        case 1:  return "orcsmasherflail";    // Orc Smasher Flail
        case 2:  return "beltoftherang001";   // Belt of the Rohirrin Ranger
        case 3:  return "greaterfirearrow";   // Greater Fire Arrows
        case 4:  return "gondorianhelm";      // Gondorian Helm
        case 5:  return "armhe009";           // Shadows' Hood
        case 6:  return "shroudoffog";        // Shroud of Fog
        case 7:  return "halberd005";         // Halberd of the Rohir
        case 8:  return "gondorianrobes";     // Gondorian Robes
        case 9:  return "138";                // Cloak of Dol Guldur
        case 10: return "dragonsbreath4";     // Dragon's Breath +4
        case 11: return "013";                // Armor of The Defender
        case 12: return "bootsofquicke002";   // Boots of Quickening
        case 13: return "100";                // Cover of Darkness
        case 14: return "deadlycaress";       // Deadly Caress
        case 15: return "043";                // Arrow of the Orc Defender
        case 16: return "044";                // Arrow of the Orc Defender
        case 17: return "staffoftheistari";   // Staff of the Istari
        case 18: return "027";                // Belt of the Dancer
        case 19: return "139";                // Ring of the Black Rider
        case 20: return "item088";            // Glove of the Hobbits
        case 21: return "shieldofthegreyw";   // Shield of the Grey Walker
        case 22: return "049";                // Boots of the Orc Defender
        case 23: return "039";                // Ring of Speed and Magic Defenses
        case 24: return "005";                // Shell
        case 25: return "urukhaiwhitehand";   // Uruk Hai White Mask
        case 26: return "glovstonehear001";   // Greater Gloves of the Stone Heart
        case 27: return "shieldofthepr001";   // Shield of the Priest
        case 28: return "gondorianplat001";   // Greater Gondorian Plate
        case 29: return "daggerofthest001";   // Dagger of the Stars
        case 30: return "gondorianlongswo";   // Gondorian Longsword
        case 31: return "fleshoftheund003";   // Rags of an Underlord
        case 32: return "gondorianlightar";   // Gondorian Light Armor
        case 33: return "eyesoftheforest";    // Eyes of The Forest
        case 34: return "wallofpain";         // Wall of Pain
        case 35: return "ixilsspike5";        // Ixil's Spike +5
        case 36: return "001";                // Stave of Slaughter
        case 37: return "ashmlw006";          // Shield of the Mage
        case 38: return "cloakofthebard";     // Cloak of the Bard
        case 39: return "crossbowofthedef";   // Crossbow of the Defender
        case 40: return "072";                // Glove of a Devoured Rogue
        case 41: return "cloakofminastiri";   // Cloak of Minas Tirith
        case 42: return "blackheartarmor";    // Blackheart Armor
        case 43: return "easterlinglaunch";   // Easterling Launcher
        case 44: return "nazgulamulet";       // Nazgul Amulet
        case 45: return "elitebolt";          // Elite Bolt
        case 46: return "mordororcstandar";   // Ordurin-Forged Plate
        case 47: return "shieldofkings";      // Shield of Kings
        case 48: return "042";                // Belt of the Orc Defender
        case 49: return "bowoftheprotecto";   // Bow of the Protector
        case 50: return "bootsofquicke004";   // Soft Step
        case 51: return "cloakofdarkness";    // Cloak of Pale Darkness
        case 52: return "117";                // Messenger's Robe
        case 53: return "cloth028";           // Leather of Shadows
        case 54: return "rubyofpower";        // Ruby of Power
        case 55: return "felloak";            // Felloak
        case 56: return "amuletofdivin003";   // Amulet of Unfaithful
        case 57: return "bootsoftheharper";   // Boots of the Harper Scout
        case 58: return "wammar051";          // Arwen's Arrow
        case 59: return "031";                // Helm's Deep Shield
        case 60: return "forestguard";        // Forest Guard shield
        case 61: return "bootsofquickenin";   // Boots of the Rivendell Ranger
        case 62: return "doomstouch";         // Dooms Touch
        case 63: return "loriengarb003";      // Lorien Garb
        case 64: return "helmoftheriderma";   // Helm of the Elite Rohirrim Soldier
        case 65: return "aarcl008";           // Rohirrin Heavy Armour
        case 66: return "gondorianstaff";     // Gondorian Staff
        case 67: return "item021";            // Sauron's Mesh
        case 68: return "wammar050";          // Angmar's Piercing Arrow
        case 69: return "shieldofthedwarv";   // Shield of the Dwarven Cleric
        case 70: return "item034";            // Dragon's Tear
        case 71: return "greaterringof003";   // Greater Ring of Power
        case 72: return "longbowofdeath";     // Longbow of Death
        case 73: return "item111";            // Mordor Archer Bow
        case 74: return "bowofthegaladhri";   // Bow of the Galadhrim
        case 75: return "ringofthedwarf";     // Ring of the Dwarf
        case 76: return "maarcl002";          // Personal Guard Armor
        case 77: return "item133";            // Nature's Wrap
        case 78: return "126";                // Forged Boots of the Orc General
        case 79: return "ringofjustice";      // Ring of Justice
        case 80: return "adamantitetow001";   // Fine Dwarven Tower Shield
        case 81: return "arangerdefender";    // A Ranger Defender
        case 82: return "gondorianplat002";   // Gondorian Captain's Plate
        case 83: return "shieldofthero001";   // Shield of The Fleet Elf
        case 84: return "headsplitter002";    // Black Numenorian Slasher
        case 85: return "helmofthehighcle";   // Helm of the High Cleric
        case 86: return "poisontippedf002";   // Poison Tipped Fang
        case 87: return "wingsofmirkwood";    // Wings of Mirkwood
        case 88: return "unholysigil";        // Unholy Sigil
        case 89: return "axeofthewarrioro";   // Axe of the Warrior Orc
    }
    return "";
}

// --- helper: good-side city loot ---
void SpawnGoodCityLoot(object oChest, int nCity)
{
    switch (nCity)
    {
        case 0: // Gondor
            // Gondorian Bowman (8) vs Epic Gondorian Guardsman (2)
            if (Random(2) == 0)
                CreateIDItem("boltoftheblackel", oChest, 99);
            else {
                CreateIDItem("nw_it_mpotion009", oChest);
                CreateIDItem("nw_it_mpotion016", oChest);
            }
            break;

        case 1: // Helms Deep
            // Helm's Deep Elite Guard (6) vs Defender of the Deep (6)
            if (Random(2) == 0) {
                CreateIDItem("nw_it_mpotion003", oChest, 2);
                CreateIDItem("nw_it_mpotion009", oChest, 2);
            } else
                CreateIDItem("012", oChest);      // Helm of the Defender
            break;

        case 2: // Rivendell
            // Forest Guardian of Rivendell (6)
            CreateIDItem("eyesoftheforest", oChest);
            CreateIDItem("nw_it_mbelt021",  oChest);
            break;

        case 3: // Lothlorien
            // Galadhrim Arcane Archer (12) vs Galadhrim Shield Guardian (11)
            if (Random(2) == 0)
                CreateIDItem("wammar029", oChest, 99);    // Cold Arrows
            else {
                CreateIDItem("nw_it_mpotion016", oChest);
                CreateIDItem("nw_it_mpotion005", oChest);
            }
            break;

        case 4: // Edoras
            // Ridermark Guardian (8)
            CreateIDItem("nw_it_mpotion012", oChest);
            CreateIDItem("nw_it_mpotion015", oChest);
            CreateIDItem("nw_it_mpotion009", oChest);
            CreateIDItem("nw_it_mpotion016", oChest);
            break;
    }
}

// --- helper: evil-side city loot ---
void SpawnEvilCityLoot(object oChest, int nCity)
{
    switch (nCity)
    {
        case 0: // Morannan / Black Gate
            // Archer of Mordor (12)
            CreateIDItem("wammar055", oChest, 99);        // Mordor Slayers
            break;

        case 1: // Isengard
            // Dunlending Shock Trooper (5)
            CreateIDItem("nw_it_mpotion004", oChest);
            CreateIDItem("nw_it_mpotion003", oChest);
            CreateIDItem("nw_it_mpotion014", oChest);
            CreateIDItem("gauntletsofdexte", oChest);     // Gauntlets of Dex +6
            break;

        case 2: // Cirith Ungol
            // Mordor Orc Snaker (4) vs Mordor Slaughterer (3)
            CreateIDItem("nw_it_mpotion015", oChest);
            CreateIDItem("nw_it_mpotion003", oChest);
            if (Random(2) == 0)
                CreateIDItem("mordoraxe", oChest);
            break;

        case 3: // Carn Dum
            // Black Numenorean Militia (6)
            CreateIDItem("nw_it_mpotion009", oChest);
            CreateIDItem("nw_it_mpotion013", oChest);
            break;
    }
}

// --- stock the chest once per server reset ---
void StockDonationsChest()
{
    object oMod = GetModule();
    if (GetLocalInt(oMod, "DONATIONS_STOCKED")) return;
    SetLocalInt(oMod, "DONATIONS_STOCKED", 1);

    object oChest = GetObjectByTag("x2_easy_Chest2ff");
    if (!GetIsObjectValid(oChest)) return;

    // Random good-side city: 0=Gondor 1=Helms Deep 2=Rivendell 3=Lothlorien 4=Edoras
    SpawnGoodCityLoot(oChest, Random(5));
    // Random evil-side city: 0=Black Gate 1=Isengard 2=Cirith Ungol 3=Carn Dum
    SpawnEvilCityLoot(oChest, Random(4));

    // Two distinct bonus items from the full 200k-500k custom item pool
    int nPoolSize = 90;
    int nPick1 = Random(nPoolSize);
    int nPick2 = Random(nPoolSize - 1);
    if (nPick2 >= nPick1) nPick2++;     // guarantee nPick2 != nPick1

    string sItem1 = GetBonusItemResref(nPick1);
    string sItem2 = GetBonusItemResref(nPick2);
    if (sItem1 != "") CreateIDItem(sItem1, oChest, GetBonusItemStackSize(nPick1));
    if (sItem2 != "") CreateIDItem(sItem2, oChest, GetBonusItemStackSize(nPick2));
}

void main()
{
    object oPC = GetEnteringObject();

    // Starter XP + welcome message for brand-new characters
    if (!GetIsDM(oPC) && GetXP(oPC) == 0)
    {
        GiveXPToCreature(oPC, 3000);
        SendMessageToPC(oPC, "Welcome to Homer's Legendary Lord of the Rings!");
        SendMessageToPC(oPC, "The light of Eru smiles upon you, new adventurer. "
            + "You have been granted 3000 experience points to begin your journey. "
            + "Check the Donations Chest near the Well Mart — it may hold something "
            + "useful to help you on your way. Good luck, and may your path through "
            + "Middle-earth be legendary!");
    }

    StockDonationsChest();
}
