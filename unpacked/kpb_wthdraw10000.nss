void main()
{
object oPC = GetPCSpeaker();
int nWithdraw = 1000000;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
int nAmount = (nBalance - nWithdraw);
int nGold = GetGold(oPC);
if (nBalance >= 1000000)
    {
    GiveGoldToCreature(oPC, nWithdraw);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
    }
else
    {
    SpeakString("Psh, you ain't no Donald Trump, get a job.", TALKVOLUME_TALK);
    }
}
