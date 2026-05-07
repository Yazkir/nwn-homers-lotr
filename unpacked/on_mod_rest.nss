#include "pers_state_inc"

void main()
{
object oPC = GetLastPCRested();
int iMamber = GetCampaignInt("cRegistred","iMamber",oPC);
if(GetLastRestEventType() == REST_EVENTTYPE_REST_STARTED)
{
AssignCommand(oPC, ClearAllActions(TRUE));

AssignCommand(oPC,ActionStartConversation(oPC,"emotewand",TRUE));
return;
}
if (GetLastRestEventType() == REST_EVENTTYPE_REST_FINISHED)
{
    // Re-snapshot to capture the freshly-rested HP / spell / feat
    // state so a logout immediately after rest restores correctly.
    PersState_Snapshot(oPC);
}
}
