void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("well2apear");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
