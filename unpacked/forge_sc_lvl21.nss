#include "forge_inc"

int StartingConditional()
{

object oAnvil = GetNearestObjectByTag("pAnvilOfWonder");
    if (oAnvil != OBJECT_INVALID)
        {
        object oItem = GetFirstItemInInventory(oAnvil);
        if (oItem != OBJECT_INVALID)
            {
            if (!(ForgeItemValue(oItem) >= 220000)) return FALSE;
            }
         }
return TRUE;
}




