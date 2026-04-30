void main()
{
object oPC = GetPCSpeaker();
int nWithdraw = 500000;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
int nAmount = (nBalance - nWithdraw);
int nGold = GetGold(oPC);
if (nBalance >= 500000)
    {
    GiveGoldToCreature(oPC, nWithdraw);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
    }
else
    {
    SpeakString("Sorry, you do not have enough gold to withdraw that much.", TALKVOLUME_TALK);
    }
}
