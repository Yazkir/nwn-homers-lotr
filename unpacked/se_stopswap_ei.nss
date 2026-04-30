#include "se_stopswap_inc"


// -----------------------------------------------------------------------------
//  MAIN
// -----------------------------------------------------------------------------

// module event - UnPlayerEquipItem
// file name - se_stopswap_ei  v1.2
void main()
{
    object oItem = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();

    // is this the key?
    int nSlot = GetRestictedInventorySlot(oItem);
    if(GetLocalObject(oPC, VAR_SLOT_KEY + IntToString(nSlot)) == oItem)
    {
        // unlock the slot
        DeleteLocalInt(oPC, VAR_SLOT_LOCK + IntToString(nSlot));
        DeleteLocalObject(oPC, VAR_SLOT_KEY + IntToString(nSlot));
    }
}
