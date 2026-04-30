void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("minashome");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
