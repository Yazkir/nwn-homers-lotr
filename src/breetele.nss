void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("breeenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
