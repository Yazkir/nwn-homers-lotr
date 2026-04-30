void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("secondchance");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
