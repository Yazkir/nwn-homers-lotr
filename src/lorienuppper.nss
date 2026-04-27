void main()
{
 object oPC=GetLastUsedBy();
 object theWaypoint = GetWaypointByTag("tree2main");
 location rivendelia = GetLocation(theWaypoint);
 AssignCommand(oPC, JumpToLocation(rivendelia));

}
