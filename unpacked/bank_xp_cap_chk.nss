int StartingConditional()
{
string sCDKey = GetPCPublicCDKey(GetPCSpeaker());
int iBankXP = GetCampaignInt("bankdb", "fam_xp_" + sCDKey);
if(iBankXP < 1) return 0;
int iCurrentXP = GetXP(GetPCSpeaker());
if(iCurrentXP >= 17498600) return 0;
if(iCurrentXP + iBankXP <= 17498600) return 0;
return 1;
}
