void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    int iBaseValue = GetLocalInt(oItem, "FORGE_BASE_VALUE");
    int iBaseRefund = iBaseValue * 50 / 100;
    if (iBaseRefund > 60000) iBaseRefund = 60000;
    SetCustomToken(101, IntToString(GetLocalInt(oItem, "FORGE_GP_INVESTED") + iBaseRefund));
}
