     void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("KarCry2");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
