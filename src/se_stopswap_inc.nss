// file name - se_stopswap_inc v1.2
#include "x2_inc_itemprop"


// -----------------------------------------------------------------------------
//  CONSTANTS
// -----------------------------------------------------------------------------

const float SAFE_DISTANCE             = 5.0;  // Set safe distance to equip items during combat
const int LAST_PC_APPEARANCE_TYPE     = 6;    // Last standard racial type
const int UNEQUIP_WEAPON_PROVOKES_AOO = TRUE; // TRUE or FALSE

const string VAR_SLOT_KEY   = "SLOT_KEY_";
const string VAR_SLOT_LOCK  = "SLOT_LOCK_";


// -----------------------------------------------------------------------------
//  PROTOTYPES
// -----------------------------------------------------------------------------

int GetIsRestrictedSlot(int nSlot);

int GetRestictedInventorySlot(object oItem);

int GetRestrictedInventorySlotByType(int nType);

// Check if PC is in combat & within the unsafe distance,
// & if they equip a melee or ranged weapon if so,
// create an attack of opportunity
// oPC   - Player
// oItem - Check if melee or ranged weapon
int GetWasWeaponUnequippedInMelee(object oPC, object oItem);

int GetIsOkayToUnequip(object oPC, object oItem);

void ActionStepBackwards(object oCreature, float fDistance);


// -----------------------------------------------------------------------------
//  FUNCTIONS
// -----------------------------------------------------------------------------

int GetIsRestrictedSlot(int nSlot)
{
    return nSlot > -1;
}


int GetRestictedInventorySlot(object oItem)
{
    return GetRestrictedInventorySlotByType(GetBaseItemType(oItem));
}


int GetRestrictedInventorySlotByType(int nType)
{
    int nRet = -1;
    switch (nType)
    {
        case BASE_ITEM_AMULET:      nRet = INVENTORY_SLOT_NECK;  break;
        case BASE_ITEM_BELT:        nRet = INVENTORY_SLOT_BELT;  break;
        case BASE_ITEM_BOOTS:       nRet = INVENTORY_SLOT_BOOTS; break;
        case BASE_ITEM_CLOAK:       nRet = INVENTORY_SLOT_CLOAK; break;
        case BASE_ITEM_BRACER:
        case BASE_ITEM_GLOVES:      nRet = INVENTORY_SLOT_ARMS;  break;
        case BASE_ITEM_HELMET:      nRet = INVENTORY_SLOT_HEAD;  break;
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_TOWERSHIELD: nRet = INVENTORY_SLOT_LEFTHAND; break;
    }
    return nRet;
}


int GetWasWeaponUnequippedInMelee(object oPC, object oItem)
{
    // is it a weapon?
    if(IPGetIsMeleeWeapon(oItem) || IPGetIsRangedWeapon(oItem))
    {
        // is the PC in combat?
        if(GetIsInCombat(oPC))
        {
            // is the nearest enemy in striking range?
            object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);
            if(GetDistanceBetween(oPC, oEnemy) < SAFE_DISTANCE)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}


int GetIsOkayToUnequip(object oPC, object oItem)
{
    int nSlot = GetRestictedInventorySlot(oItem);

    // is the slot locked?
    // NOTE: if we are trying to unequip something from a locked slot then it
    // is the system doing the unequipping
    if(GetLocalInt(oPC, VAR_SLOT_LOCK + IntToString(nSlot)))
    {
        return TRUE;
    }

    // is it a restricted slot?
    if(GetIsRestrictedSlot(nSlot))
    {
        // is PC in combat
        if(GetIsInCombat(oPC))
        {
            // is enemy too close
            object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);
            if(GetDistanceBetween(oPC, oEnemy) < SAFE_DISTANCE)
            {
                return FALSE;
            }
        }
    }

    // at least one condition was not met so it is okay to unequip
    return TRUE;
}


void ActionStepBackwards(object oCreature, float fDistance)
{
    // decompose the creature's current location
    object oArea = GetArea(oCreature);
    vector vPosition = GetPosition(oCreature);
    float fFacing = GetFacing(oCreature);

    // generate a position behind the creature
    float fX = fDistance * cos(fFacing + 180.0);
    float fY = fDistance * sin(fFacing + 180.0);
    vector vBackwards = Vector(fX, fY);

    // generate a location behind the creature
    location lBackwards = Location(oArea, vPosition + vBackwards, fFacing);

    // force the creature to run there
    AssignCommand(oCreature, ClearAllActions());
    AssignCommand(oCreature, ActionMoveToLocation(lBackwards, TRUE));
}
