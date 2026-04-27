void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("PortDol");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
