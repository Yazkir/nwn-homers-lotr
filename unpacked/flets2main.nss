void main()
{
 object oPC=GetLastUsedBy();
 object theWaypoint = GetWaypointByTag("flets2main");
 location rivendelia = GetLocation(theWaypoint);
 AssignCommand(oPC, JumpToLocation(rivendelia));

}
