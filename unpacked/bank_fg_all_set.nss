void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
int iFamGP = GetCampaignInt("bankdb", "fam_bankgp_" + sCDKey);
if(GetLocalInt(oPC, "fam_gold_flag") == 1)
   {
   int iGP = GetGold(oPC);
   TakeGoldFromCreature(iGP, oPC);
   SetCampaignInt("bankdb", "fam_bankgp_" + sCDKey, iFamGP + iGP);
   }
if(GetLocalInt(oPC, "fam_gold_flag") == 2)
   {
   GiveGoldToCreature(oPC, iFamGP);
   SetCampaignInt("bankdb", "fam_bankgp_" + sCDKey, 0);
   }
SetCustomToken(6001, IntToString(GetCampaignInt("bankdb", "fam_bankgp_" + sCDKey)));
}
