void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
int iGP = 10;
int iFamGP = GetCampaignInt("bankdb", "fam_bankgp_" + sCDKey);
if(GetLocalInt(oPC, "fam_gold_flag") == 1)
   {
   TakeGoldFromCreature(iGP, oPC);
   SetCampaignInt("bankdb", "fam_bankgp_" + sCDKey, iFamGP + iGP);
   }
if(GetLocalInt(oPC, "fam_gold_flag") == 2)
   {
   GiveGoldToCreature(oPC, iGP);
   SetCampaignInt("bankdb", "fam_bankgp_" + sCDKey, iFamGP - iGP);
   }
SetCustomToken(6001, IntToString(GetCampaignInt("bankdb", "fam_bankgp_" + sCDKey)));
}
