void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("rivendellenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
