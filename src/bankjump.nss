void main()
{
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("BankofBree");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));
}
