void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("hennethenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
