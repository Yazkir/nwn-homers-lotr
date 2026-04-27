void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("tharenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
