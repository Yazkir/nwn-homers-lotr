void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
SetLocalInt(oPC, "fam_gold_flag", 1);
SetCustomToken(6001, IntToString(GetCampaignInt("bankdb", "fam_bankgp_" + sCDKey)));
}
