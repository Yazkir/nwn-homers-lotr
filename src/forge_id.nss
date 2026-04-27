void main()
{
object oAnvil = GetNearestObjectByTag("ForgeAnvil");
  if (oAnvil != OBJECT_INVALID)
        {
        object oItem = GetFirstItemInInventory(oAnvil);
         SetIdentified(oItem, TRUE);
         }
}
