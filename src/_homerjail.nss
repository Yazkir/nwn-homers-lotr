void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("Jailport");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
