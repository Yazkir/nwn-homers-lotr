void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("Gwathdor2");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
