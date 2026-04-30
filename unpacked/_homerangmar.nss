void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("lairjump");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
