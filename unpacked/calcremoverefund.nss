void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");
    SetCustomToken(101, IntToString(GetLocalInt(oItem, "FORGE_GP_INVESTED")));
}
