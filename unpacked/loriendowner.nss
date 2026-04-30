void main()
{
 object oPC=GetLastUsedBy();
 object theWaypoint = GetWaypointByTag("main2tree");
 location rivendelia = GetLocation(theWaypoint);
 AssignCommand(oPC, JumpToLocation(rivendelia));

}
