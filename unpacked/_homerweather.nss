  void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("weathertop");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
