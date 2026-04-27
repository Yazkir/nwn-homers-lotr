void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("edorenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
