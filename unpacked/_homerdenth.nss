void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("GonDen");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
