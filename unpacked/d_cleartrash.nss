void TrashObject(object oObject)

{
     /* search and destroy contents of body bag's, others just destroy */
    if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE) {

        object oItem = GetFirstItemInInventory(oObject);

        /* recursively trash all items inside container */
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

/* bypass if currently in-progress (blocked) or ClearTrash is disabled */
if ((GetLocalInt(OBJECT_SELF, "CT_IN_PROGRESS") != 1) &&
     (GetLocalInt(GetModule(), "CT_DISABLED") != 1))
{

    SetLocalInt(OBJECT_SELF, "CT_IN_PROGRESS", 1); /* set a flag to block */

    int iItemDestructTime;
    int iObjectType;

    int iObjectsDestroyed = 0;
    int iObjectsToDestroy = 25;  /* adjust as desired */
    int iNow = (GetCalendarMonth()*10000) + (GetCalendarDay()*100) + GetTimeHour();
    int iAreaDestructTime = iNow + 4;  /* destroy items in 'n' game hours from now */

    object oItem = GetFirstObjectInArea();

    while (GetIsObjectValid(oItem))
    {
        iObjectType = GetObjectType(oItem);

        switch (iObjectType) {
        case OBJECT_TYPE_PLACEABLE:

            /* monster drop containers are tagged placeables */
            if (GetTag(oItem) != "BodyBag") {
                break; }

            /* note: no break here, allow fall-through */

        case OBJECT_TYPE_ITEM:

            iItemDestructTime = GetLocalInt(oItem, "CT_DESTRUCT_TIME");

            if (iItemDestructTime > 0)
            {
                if (iItemDestructTime <= iNow) {
                    TrashObject(oItem);   /* destruct time has passed, trash the object */
                    iObjectsDestroyed++;
                }

                /* note: no action if destruct time set but not passed */

            } else {

                /* no destruct time set, so do it now */
                SetLocalInt(oItem, "CT_DESTRUCT_TIME", iAreaDestructTime);
            }
        }

        if (iObjectsDestroyed < iObjectsToDestroy) {
            oItem = GetNextObjectInArea();
        } else {
            break;  /* destroyed enough objects, get out of loop */
        }
    }

    SetLocalInt(OBJECT_SELF, "CT_IN_PROGRESS", 0);  /* done, release */

}  /* if (not blocked or disabled) */
}  /* main() */
