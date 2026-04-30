void main()
{
//this script destroys all items in the bin every time it is opened.
//aldaron 12042004

object oCurrentItem = GetFirstItemInInventory (OBJECT_SELF);

while (GetIsObjectValid(oCurrentItem))
{
DestroyObject (oCurrentItem);

oCurrentItem = GetNextItemInInventory(OBJECT_SELF);
}

}
