void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("lorienup");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
