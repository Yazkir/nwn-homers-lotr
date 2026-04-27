 void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("Bilbos");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
