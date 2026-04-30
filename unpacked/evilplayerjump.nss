
void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("NW_HOME2");
location evilplayerjump2 = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(evilplayerjump2));
}

