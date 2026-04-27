void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("dunharrowenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}

