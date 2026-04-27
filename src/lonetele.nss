void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("loneenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
