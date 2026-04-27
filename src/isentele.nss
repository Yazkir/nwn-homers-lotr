void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("isenenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
