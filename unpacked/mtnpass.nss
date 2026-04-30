void main()
{
object oPC = GetPCSpeaker();
object theWaypoint = GetWaypointByTag("silverenter1");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
