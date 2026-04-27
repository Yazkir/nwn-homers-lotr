void main()
{
object oPC = GetPCSpeaker();
int nWithdraw = 100000;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
int nAmount = (nBalance - nWithdraw);
int nGold = GetGold(oPC);
if (nBalance >= 100000)
    {
    GiveGoldToCreature(oPC, nWithdraw);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
    }
else
    {
    SpeakString("The bums will always lose Lebowski!! Get a job, ya brokeass", TALKVOLUME_TALK);
    }
}
