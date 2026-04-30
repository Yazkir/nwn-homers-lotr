void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("DispairPort");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
