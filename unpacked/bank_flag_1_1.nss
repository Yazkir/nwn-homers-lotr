void main()
{
SetLocalInt(GetPCSpeaker(), "flag_1", 1);
SetCustomToken(6000, IntToString(GetCampaignInt("bankdb", "bankgp", GetPCSpeaker())));
return;
}
