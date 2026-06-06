void main()
{
object oAnvil = GetNearestObjectByTag("pAnvilOfWonder");
  if (oAnvil != OBJECT_INVALID)
        {
        object oItem = GetFirstItemInInventory(oAnvil);
         SetIdentified(oItem, TRUE);
         }
}
