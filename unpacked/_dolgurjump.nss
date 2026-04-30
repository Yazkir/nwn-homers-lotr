void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("dolgurjump");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
