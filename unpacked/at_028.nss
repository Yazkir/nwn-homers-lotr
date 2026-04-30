//::///////////////////////////////////////////////
//:: FileName at_028
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/10/2002 2:40:40 PM
//:://////////////////////////////////////////////
void main()
{

    // Remove some gold from the player
    TakeGoldFromCreature(700, GetPCSpeaker(), FALSE);
    // Set the variables
    SetLocalInt(GetPCSpeaker(), "kallrist", 1);
object oPC = GetLastSpeaker();
object theWaypoint = GetWaypointByTag("callrisenter");
location rivendelia = GetLocation(theWaypoint);

AssignCommand(oPC, JumpToLocation(rivendelia));

}
