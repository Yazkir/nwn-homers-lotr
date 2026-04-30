void main()
{
 object oPC=GetLastUsedBy();
 object theWaypoint = GetWaypointByTag("main2flets");
 location rivendelia = GetLocation(theWaypoint);
 AssignCommand(oPC, JumpToLocation(rivendelia));

}
