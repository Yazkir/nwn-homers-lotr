void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("helmkeepport");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
