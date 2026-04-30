void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("battle");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
