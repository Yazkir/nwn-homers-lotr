void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("NW_HOME3");
location goodplayerjump2 = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(goodplayerjump2));
}


