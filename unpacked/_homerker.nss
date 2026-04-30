void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("KerJump");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
