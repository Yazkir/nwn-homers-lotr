void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("WP_Homeless");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
