//::///////////////////////////////////////////////
//:: FileName at_029
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/10/2002 2:42:11 PM
//:://////////////////////////////////////////////
void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("callrisexit");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));

}
