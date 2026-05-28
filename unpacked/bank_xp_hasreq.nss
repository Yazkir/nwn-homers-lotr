int StartingConditional()
{
string sCDKey = GetPCPublicCDKey(GetPCSpeaker());
if(GetCampaignInt("bankdb", "fam_account_" + sCDKey) < 1) return 0;
if(GetCampaignInt("bankdb", "fam_gold_acct_" + sCDKey) < 1) return 0;
return 1;
}
