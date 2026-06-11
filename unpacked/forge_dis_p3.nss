// Pick disenchant slot 3 and stage its name in token 6118 for the confirm.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    SetLocalInt(oPC, "FORGE_DIS_PICK", 3);
    SetCustomToken(6118, ForgePropName(ForgeGetPermPropByIndex(
        GetLocalObject(oPC, "FORGE_DIS_ITEM"), 3)));
}
