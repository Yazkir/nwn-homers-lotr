#include "itemprocs"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");

    itemproperty ip = GetNewProperty(oItem);

    //Copy item and modify to get new value
    if ( GetIsItemPropertyValid(ip))
        {
        object oCopy = CopyItem(oItem, OBJECT_SELF);
        CustomAddProperty(oCopy, ip);
        SetLocalObject(oPC, "MODIFY_COPY", oCopy);
        }
    else
        SendMessageToPC(oPC, "ERROR: Invalid Property");


}
