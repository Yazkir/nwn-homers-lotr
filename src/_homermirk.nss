void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("Green");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
