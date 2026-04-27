void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("mtdoom111");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
