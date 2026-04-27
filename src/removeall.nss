void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    int iValue = GetGoldPieceValue(oItem);

    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
        {
        RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
        }

    GiveGoldToCreature(oPC, iValue);
}

