void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("blackenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}

