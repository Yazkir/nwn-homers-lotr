void TrashObject(object oObject)
{
    if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE) {
        object oItem = GetFirstItemInInventory(oObject);
        while (GetIsObjectValid(oItem))
        {
            TrashObject(oItem);
           oItem = GetNextItemInInventory(oObject);
        }
    }
    DestroyObject(oObject);
}
void main()
{
    if(!GetIsPC(GetExitingObject()) ) {
        return; }
object oPC = GetExitingObject();
    if (!GetIsPC(oPC))
        return;
    oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID)
    {
        if (OBJECT_SELF == GetArea(oPC))
            return;
        else oPC = GetNextPC();
    }
    object oObject = GetFirstObjectInArea(OBJECT_SELF);
    while (oObject != OBJECT_INVALID)
    {
        if (GetIsEncounterCreature(oObject))
            DestroyObject(oObject);
        oObject = GetNextObjectInArea(OBJECT_SELF);
}
    object oItem = GetFirstObjectInArea();
    while (GetIsObjectValid(oItem))
    {
       int iObjectType = GetObjectType(oItem);
        switch (iObjectType) {
        case OBJECT_TYPE_PLACEABLE:
     if (GetTag(oItem) != "BodyBag") {
                break; }
        case OBJECT_TYPE_ITEM:
        TrashObject(oItem); }
        oItem = GetNextObjectInArea();
}
}
