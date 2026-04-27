void main()
{
object oPC = GetPCSpeaker();
int nDeposit = 500000;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
int nAmount = (nDeposit + nBalance);
int nGold = GetGold(oPC);
int iMonth = GetCalendarMonth();
int iDay = GetCalendarDay();
int iYear = GetCalendarYear();
if (nGold >= 500000)
    {
    TakeGoldFromCreature(nDeposit, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
    SetCampaignInt("kpb_bank", "KPB_DEPO_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_DEPO_DAY", iDay, oPC);
    SetCampaignInt("kpb_bank", "KPB_DEPO_MONTH", iMonth, oPC);
    }
else
    {
    SpeakString("Sorry man, you do not have enough gold to deposit.", TALKVOLUME_TALK);
    }
}
