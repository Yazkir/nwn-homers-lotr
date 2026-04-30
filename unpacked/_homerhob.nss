void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("hobtele");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
