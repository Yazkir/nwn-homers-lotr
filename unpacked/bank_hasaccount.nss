int StartingConditional()
{
int iFlag;
if((GetCampaignInt("bankdb", "bank_account", GetPCSpeaker())) >= 1)
   {iFlag = 1;}
   else
   {iFlag = 0;}
return iFlag;
}
