#include "se_stopswap_inc"


// -----------------------------------------------------------------------------
//  MAIN
// -----------------------------------------------------------------------------

// module event - OnPlayerUnEquipItem
// file name - se_stopswap_uei  v1.2
void main()
{
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();

    // pre-emptive abort: if the PC's appearance is not a standard PC appearance
    // type the PC is/has just polymorphed which merges inventory slots  so no
    // need for restrictions on swapping items
    if(GetAppearanceType(oPC) > LAST_PC_APPEARANCE_TYPE)
    {
       return;
    }

    // Check if PC is in combat & within the unsafe distance, & if they equip a
    // melee or ranged weapon if so, create an attack of opportunity
    if(GetWasWeaponUnequippedInMelee(oPC, oItem) && UNEQUIP_WEAPON_PROVOKES_AOO)
    {
        ActionStepBackwards(oPC, 2.5);
        SendMessageToPC(oPC, "You move back to unequip " + GetName(oItem) + " while this close to combat!");
    }
    else if(GetIsOkayToUnequip(oPC, oItem) == FALSE)
    {
        int nSlot = GetRestictedInventorySlot(oItem);

        // lock the slot and note the key
        SetLocalInt(oPC, VAR_SLOT_LOCK + IntToString(nSlot), TRUE);
        SetLocalObject(oPC, VAR_SLOT_KEY + IntToString(nSlot), oItem);

        // force the PC to re-equip the item
        AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
        SendMessageToPC(oPC, "You can't unequip " + GetName(oItem) + " this close to combat!");
    }
}
