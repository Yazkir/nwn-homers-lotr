void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    int iRefund = GetLocalInt(oItem, "FORGE_GP_INVESTED");

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

