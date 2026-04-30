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
}
