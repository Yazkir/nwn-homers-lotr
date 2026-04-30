void main()
{
    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    while ( oItem != OBJECT_INVALID )
        {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(OBJECT_SELF);
        }
}
