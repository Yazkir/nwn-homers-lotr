void main()
{
object oPC = GetPCSpeaker();
int iGP = GetGold(oPC);
int iPCGP = GetCampaignInt("bankdb", "bankgp", oPC);
if((GetLocalInt(oPC, "flag_1")) == 1)
   {
   TakeGoldFromCreature(iGP, oPC);
   SetCampaignInt("bankdb", "bankgp", iPCGP + iGP, oPC);
   }
if((GetLocalInt(oPC, "flag_1")) == 2)
   {
   GiveGoldToCreature(oPC, iPCGP);
   SetCampaignInt("bankdb", "bankgp", 0, oPC);
   }
SetCustomToken(6000, IntToString(GetCampaignInt("bankdb", "bankgp", GetPCSpeaker())));

return;
}
