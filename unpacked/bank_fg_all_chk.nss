int StartingConditional()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
if(GetLocalInt(oPC, "fam_gold_flag") == 1)
   {if(GetGold(oPC) >= 1) return 1; return 0;}
if(GetLocalInt(oPC, "fam_gold_flag") == 2)
   {if(GetCampaignInt("bankdb", "fam_bankgp_" + sCDKey) >= 1) return 1; return 0;}
return 0;
}
