#include "itemprocs"

void main()
{
    object oPC = GetPCSpeaker();

    //Transfer gold
    int iValue = GetLocalInt(oPC, "MODIFY_VALUE");
    int iDiff = GetLocalInt(oPC, "MODIFY_DIFF");
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    if (iDiff == 1 && GetGold(oPC) < iValue)
        {
        SpeakString("Oops.. looks like you don't have the gold for this.");
        return;
        }

    if (iDiff == 1)
        {
        TakeGoldFromCreature(iValue, oPC, TRUE);
        SetLocalInt(oItem, "FORGE_GP_INVESTED",
            GetLocalInt(oItem, "FORGE_GP_INVESTED") + (iValue * 80 / 100));
        }
    else if (iDiff == -1)
        GiveGoldToCreature(oPC, iValue);

    //Modify item
    itemproperty ip = GetNewProperty(oItem);

    if ( GetIsItemPropertyValid(ip))
        CustomAddProperty(oItem, ip);
}
