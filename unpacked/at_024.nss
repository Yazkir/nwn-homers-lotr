//::///////////////////////////////////////////////
//:: FileName at_024
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/8/2002 1:42:54 AM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{
    object oPC = GetPCSpeaker();

    // at_026 sets this flag only after confirming and destroying both items.
    // Guard here so the dialog reaching this node can't grant a reward if
    // at_026 returned early due to missing items.
    if (!GetLocalInt(oPC, "elrond_gave_items"))
    {
        FloatingTextStringOnCreature(
            "Oops! You must present both quest items to receive Elrond's Writ.", oPC, FALSE);
        return;
    }
    DeleteLocalInt(oPC, "elrond_gave_items");

    RewardPartyXP(2000, oPC);
    CreateItemOnObject("elrondswrit", oPC, 1);
}
