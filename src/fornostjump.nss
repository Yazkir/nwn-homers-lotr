void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("fornostenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}

