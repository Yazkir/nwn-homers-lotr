// Set the chest to the proper OWNER_ID
// and then Open the inventory

#include "x0_i0_henchman"

void main()
{
    object oPC = GetPCSpeaker();

    string sCDKey = GetPCPublicCDKey(oPC);

    object oContainer = GetNearestObjectByTag("PERSISTENT_CHEST", oPC);

    SetLocalString(oContainer, "OWNER_ID", sCDKey);

    HireHenchman(GetPCSpeaker());

    OpenInventory(oContainer, oPC);

}
