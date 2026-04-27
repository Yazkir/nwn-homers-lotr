//::///////////////////////////////////////////////
//:: FileName at_030
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/10/2002 2:44:32 PM
//:://////////////////////////////////////////////
void main()
{

    // Remove some gold from the player
    TakeGoldFromCreature(500, GetPCSpeaker(), FALSE);
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("callrisenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
