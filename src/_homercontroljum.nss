void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("control");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
