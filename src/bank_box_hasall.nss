int StartingConditional()
{
object oPC = GetPCSpeaker();
int iFlag;
if(GetCampaignInt("bankdb", "bank_account", oPC) >= 5)
   {iFlag = 1;}
   else
   {iFlag = 0;}
return iFlag;
}
