/////////////////////////////////
//: Kittrell's Persistent Banking
//: kbp_ppis_disturb.css
//: Modified By: Brian J. Kittrell
//: Modified On: 19-2-2004
//:
//: Originally By: OldManWhistler
//: PPIS System
/////////////////////////////////

int PPISUserDefinedInventoryLimit(object oPC, int iCount, object oItem)
{
    // Maximum allowable items stored in the vault by any one player.
    if(iCount > 30)
    {
        SendMessageToPC(oPC, "You may not store more than 30 items.");
        return FALSE;
    }
    return TRUE;
}

const string PPIS_COUNT = "PPISCount";

void main()
{
    object oPC = GetLastDisturbed();
    if (!GetIsPC(oPC)) return;
    int iType = GetInventoryDisturbType();
    object oItem = GetInventoryDisturbItem();
    int iCount = GetLocalInt(OBJECT_SELF, PPIS_COUNT);
    if (iType == INVENTORY_DISTURB_TYPE_ADDED)
    {
        if (GetItemStackSize(oItem) > 1)
        {
            DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionGiveItem(oItem, oPC)));
            SendMessageToPC(oPC, "Gold and other stacked items cannot be stored within this container.");
        }
        if (GetHasInventory(oItem))
        {
            DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionGiveItem(oItem, oPC)));
            SendMessageToPC(oPC, "You cannot store containers in your vault.");
            return;
        }
        if(!PPISUserDefinedInventoryLimit(oPC, iCount, oItem))
        {
            DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionGiveItem(oItem, oPC)));
            return;
        }
        iCount++;
        SetLocalInt(OBJECT_SELF, PPIS_COUNT, iCount);
    }
    else if (iType == INVENTORY_DISTURB_TYPE_REMOVED)
    {
        iCount--;
        SetLocalInt(OBJECT_SELF, PPIS_COUNT, iCount);
    }
    SendMessageToPC(oPC, "The vault has "+IntToString(iCount)+" items stored.");
}
