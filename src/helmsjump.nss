  void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("helmenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
