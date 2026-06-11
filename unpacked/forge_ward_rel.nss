// Forge Warden release: send the cleared PC back to the Well of Eru.
#include "forge_inc"

void main()
{
    object oPC = GetPCSpeaker();
    // Belt and braces: never release a PC still carrying contraband.
    if (GetIsObjectValid(ForgeFindIllegalItem(oPC)))
        return;
    DeleteLocalObject(oPC, "FORGE_ILLEGAL_ITEM");
    object oWP = GetWaypointByTag("secondchance");
    if (!GetIsObjectValid(oWP))
    {
        ForgeLog("forge_ward_rel: waypoint 'secondchance' missing!");
        return;
    }
    location lWell = GetLocation(oWP);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToLocation(lWell));
}
