  void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("darklord");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
