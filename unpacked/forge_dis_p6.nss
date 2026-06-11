// Pick disenchant slot 6 and stage its name in token 6118 for the confirm.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    SetLocalInt(oPC, "FORGE_DIS_PICK", 6);
    SetCustomToken(6118, ForgePropName(ForgeGetPermPropByIndex(
        GetLocalObject(oPC, "FORGE_DIS_ITEM"), 6)));
}
