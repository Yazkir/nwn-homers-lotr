void main()
{
object oPC = GetPCSpeaker();
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
int nGold = GetGold(oPC);
int nAmount = (nGold + nBalance);
int iMonth = GetCalendarMonth();
int iDay = GetCalendarDay();
int iYear = GetCalendarYear();
if (nGold >= 1)
    {
    TakeGoldFromCreature(nGold, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
    SetCampaignInt("kpb_bank", "KPB_DEPO_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_DEPO_DAY", iDay, oPC);
    SetCampaignInt("kpb_bank", "KPB_DEPO_MONTH", iMonth, oPC);
    SpeakString("Groovey, you have deposited " + IntToString(nGold) + " gold pieces.", TALKVOLUME_TALK);
    }
else
    {
    SpeakString("Sorry, your broke.", TALKVOLUME_TALK);
    }
}
