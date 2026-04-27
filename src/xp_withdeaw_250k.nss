 #include "xp_inc"

void main()
{
object oPC =GetPCSpeaker();
  if (WithdrawCap == TRUE)
   {
    if (GetXP(oPC) >= (XPcap - 24999))
     {
     SpeakString(slvlcap);
     return;
     }
   }
string sCDKey = GetPCPublicCDKey( oPC);
int fXP = GetCampaignInt( "XP", sCDKey) - 250000;

 SetCampaignInt( "XP", sCDKey, fXP);
 GiveXPToCreature(oPC, 250000);
 SpeakString ("You have withrawn 250,000 XP.");
}
