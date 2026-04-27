void main()
{
object oPC = GetPCSpeaker();

int GoldPC=GetGold(oPC);
int iPCGP =GetCampaignInt("Bankgp",GetPCPublicCDKey(oPC)) ;
TakeGoldFromCreature(GoldPC,oPC, TRUE);
SetCampaignInt("Bankgp",GetPCPublicCDKey(oPC),iPCGP+GoldPC);
SetCustomToken(6000,IntToString(iPCGP+GoldPC));
}
