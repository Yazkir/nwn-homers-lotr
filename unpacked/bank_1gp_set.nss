void main()
{
object oPC = GetPCSpeaker();
int iGP = 1;
int iPCGP = GetCampaignInt("bankdb", "bankgp", oPC);
if((GetLocalInt(oPC, "flag_1")) == 1)
   {
   TakeGoldFromCreature(iGP, oPC);
   SetCampaignInt("bankdb", "bankgp", iPCGP + iGP, oPC);
   }
if((GetLocalInt(oPC, "flag_1")) == 2)
   {
   GiveGoldToCreature(oPC, iGP);
   SetCampaignInt("bankdb", "bankgp", iPCGP - iGP, oPC);
   }
SetCustomToken(6000, IntToString(GetCampaignInt("bankdb", "bankgp", GetPCSpeaker())));

return;
}
