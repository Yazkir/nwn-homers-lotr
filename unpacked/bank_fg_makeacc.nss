void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
SetCampaignInt("bankdb", "fam_gold_acct_" + sCDKey, 1);
SetCampaignInt("bankdb", "fam_bankgp_" + sCDKey, 0);
TakeGoldFromCreature(11500, oPC);
}
