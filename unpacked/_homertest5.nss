void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("Great");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
