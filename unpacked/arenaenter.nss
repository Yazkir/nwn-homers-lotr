void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("tour2");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
