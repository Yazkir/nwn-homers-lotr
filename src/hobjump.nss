void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("HobbitJump");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
