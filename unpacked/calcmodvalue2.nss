void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    object oCopy = GetLocalObject(oPC, "MODIFY_COPY");

    //Get values of original item and modified copy, then destroy copy
    int iCurrentValue = GetGoldPieceValue(oItem);
    int iNewValue = GetGoldPieceValue(oCopy);
    DestroyObject(oCopy);

    //Either amount to pay, refund or no change
    int iValue = 0;
    int iDiff = 0;
    if (iNewValue > iCurrentValue)
        {
        iValue = iNewValue - iCurrentValue;
        iDiff = 1; //iValue is amount to pay
        }
    else if (iNewValue < iCurrentValue)
        {
        iValue = iCurrentValue - iNewValue;
        iDiff = -1; //iValue is refund
        };
    SetLocalInt(oPC, "MODIFY_VALUE", iValue);
    SetLocalInt(oPC, "MODIFY_DIFF", iDiff);
    SetCustomToken(101, IntToString(iValue));
}
