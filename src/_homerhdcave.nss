void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("helmdeepcave");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
