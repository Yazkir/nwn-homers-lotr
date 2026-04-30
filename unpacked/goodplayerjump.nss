void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("NW_HOME");
location goodplayerjump2 = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(goodplayerjump2));
}

