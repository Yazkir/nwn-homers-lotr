void main()
{
string sCDKey = GetPCPublicCDKey(GetPCSpeaker());
SetCustomToken(6002, IntToString(GetCampaignInt("bankdb", "fam_xp_" + sCDKey)));
}
