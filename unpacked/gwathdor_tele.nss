void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("Gwathdor");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
