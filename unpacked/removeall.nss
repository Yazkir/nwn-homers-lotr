void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");

    // Refund only the forge-added value (delta from first placement), at 80%
    int iCurrentValue = GetGoldPieceValue(oItem);
    int iBaseValue = GetLocalInt(oItem, "FORGE_BASE_SET") ? GetLocalInt(oItem, "FORGE_BASE_VALUE") : iCurrentValue;
    int iRefund = (iCurrentValue > iBaseValue) ? ((iCurrentValue - iBaseValue) * 80 / 100) : 0;

    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
        {
        RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
        }

    if (iRefund > 0)
        GiveGoldToCreature(oPC, iRefund);
}

