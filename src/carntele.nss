void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("carnenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
