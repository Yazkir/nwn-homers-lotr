int StartingConditional()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
int iGP = 10;
if(GetLocalInt(oPC, "fam_gold_flag") == 1)
   {if(GetGold(oPC) >= iGP) return 1; return 0;}
if(GetLocalInt(oPC, "fam_gold_flag") == 2)
   {if(GetCampaignInt("bankdb", "fam_bankgp_" + sCDKey) >= iGP) return 1; return 0;}
return 0;
}
