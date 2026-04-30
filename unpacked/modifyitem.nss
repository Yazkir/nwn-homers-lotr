#include "itemprocs"

void main()
{
    object oPC = GetPCSpeaker();

    //Transfer gold
    int iValue = GetLocalInt(oPC, "MODIFY_VALUE");
    int iDiff = GetLocalInt(oPC, "MODIFY_DIFF");
    if (iDiff == 1)
        TakeGoldFromCreature(iValue, oPC, TRUE);
    else if (iDiff == -1)
        GiveGoldToCreature(oPC, iValue);

    //Modify item
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    itemproperty ip = GetNewProperty(oItem);

    if ( GetIsItemPropertyValid(ip))
        CustomAddProperty(oItem, ip);
}
