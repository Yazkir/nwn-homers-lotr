void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("GladWP2");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}

