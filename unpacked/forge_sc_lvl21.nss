int StartingConditional()
{

object oAnvil = GetNearestObjectByTag("ForgeAnvil");
    if (oAnvil != OBJECT_INVALID)
        {
        object oItem = GetFirstItemInInventory(oAnvil);
        if (oItem != OBJECT_INVALID)
            {
            if (!(GetGoldPieceValue(oItem) >= 220000)) return FALSE;
            }
         }
return TRUE;
}




