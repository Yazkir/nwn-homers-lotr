void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("2Agmar_WP");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
