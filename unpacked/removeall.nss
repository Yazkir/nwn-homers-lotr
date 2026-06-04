void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    int iBaseValue = GetLocalInt(oItem, "FORGE_BASE_VALUE");
    int iBaseRefund = iBaseValue * 50 / 100;
    if (iBaseRefund > 60000) iBaseRefund = 60000;
    int iRefund = GetLocalInt(oItem, "FORGE_GP_INVESTED") + iBaseRefund;

    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
        {
        RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
        }

    SetLocalInt(oItem, "FORGE_GP_INVESTED", 0);
    if (iRefund > 0)
        GiveGoldToCreature(oPC, iRefund);
}

