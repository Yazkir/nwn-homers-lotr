void main()
{
object oPC = GetPCSpeaker();
int iGP = 100000;
int GoldPC=GetGold(oPC);
int iPCGP =GetCampaignInt("Bankgp",GetPCPublicCDKey(oPC)) ;

if (GoldPC>iGP)
    {
    TakeGoldFromCreature(iGP,oPC, TRUE);
    SetCampaignInt("Bankgp",GetPCPublicCDKey(oPC),iPCGP+iGP);
    SetCustomToken(6000,IntToString(iPCGP+iGP));
    }
else
    {
    SendMessageToPC(oPC,"Not Enough Money");
    SetCustomToken(6000,IntToString(GoldPC));
    }

}
