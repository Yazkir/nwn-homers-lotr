// Markshire Persistent Chest System (MPCS)
// Thrym of Markshire
//
// OnActivate Script for Persistent Chest Key
//
/////////////////////////////////////////////

#include "ms_pc_inc"

void main()
{
    object oPC      = GetItemActivator();
    object oTarget  = GetItemActivatedTarget();

    string sCDKey   = GetPCPublicCDKey(oPC);
    string sOwnerID = GetLocalString(oTarget, "OWNER_ID");

    /* // DEBUG STRINGS
    AssignCommand(oPC, SpeakString("Target is: " + GetTag(oTarget)));
    AssignCommand(oPC, SpeakString("OWNER_ID is: " + sOwnerID));
    AssignCommand(oPC, SpeakString("PC CD Key is: " + sCDKey));
    // END DEBUG */

    if (GetLocalString(GetArea(oPC), "PC_KEY") != "SAFE")
    {
        SendMessageToPC(oPC, "You cannot summon the chest here.");
        return;
    }

    switch (GetIsObjectValid(oTarget))
    {
        case TRUE:
            switch (sOwnerID == sCDKey)
            {
                // This Object is our chest
                // So we put it away and destroy the original
                case TRUE: ms_Store_Chest(oPC, oTarget, sCDKey); break;

                // This Object is not our Chest
                case FALSE: SendMessageToPC(oPC, "Sorry, needs to be your Chest."); break;
            }
            break;

        case FALSE:
            switch (ms_Chest_Area_Check(oPC, sCDKey))
            {
                // Chest is not out already
                // So we create it at the target location
                case FALSE: ms_Retrieve_Chest(oPC, sCDKey, GetItemActivatedTargetLocation());
                    break;

                // Duh, you have it out, You can't make another one.
                case TRUE: SendMessageToPC(oPC, "The Chest is out already."); break;
            }
            break;
    }

}
