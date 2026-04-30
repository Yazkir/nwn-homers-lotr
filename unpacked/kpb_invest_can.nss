////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_invest_can - This script allows   //
//  players to cancel their investments   //
//  for a 10% charge of the investment.   //
////////////////////////////////////////////

void main()
{
object oPC = GetPCSpeaker();
int nInvestment = GetCampaignInt("kpb_bank", "KPB_INVEST_TYPE", oPC);
int nInvested = GetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", oPC);
int iMonth = GetCalendarMonth();
int iDay = GetCalendarDay();
int iYear = GetCalendarYear();
if (nInvested != 1)
    {
    SpeakString("Our records do not show you having any pending investments.", TALKVOLUME_TALK);
    SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
    }
if (nInvested == 1)
    {
        if (nInvestment == 1)
        {
        int nOriginal = 100;
        int nCharge = 10;
        int nRefund = (nOriginal - nCharge);
        SpeakString("We have refunded your " + IntToString(nRefund) + " gold pieces, with a charge of " + IntToString(nCharge) + " for early cancellation.", TALKVOLUME_TALK);
        SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
        GiveGoldToCreature(oPC, nRefund);
        }
        if (nInvestment == 2)
        {
        int nOriginal = 5000;
        int nCharge = 500;
        int nRefund = (nOriginal - nCharge);
        SpeakString("We have refunded your " + IntToString(nRefund) + " gold pieces, with a charge of " + IntToString(nCharge) + " for early cancellation.", TALKVOLUME_TALK);
        SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
        GiveGoldToCreature(oPC, nRefund);
        }
        if (nInvestment == 3)
        {
        int nOriginal = 2500;
        int nCharge = 250;
        int nRefund = (nOriginal - nCharge);
        SpeakString("We have refunded your " + IntToString(nRefund) + " gold pieces, with a charge of " + IntToString(nCharge) + " for early cancellation.", TALKVOLUME_TALK);
        SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
        GiveGoldToCreature(oPC, nRefund);
        }
        if (nInvestment == 4)
        {
        int nOriginal = 3000;
        int nCharge = 300;
        int nRefund = (nOriginal - nCharge);
        SpeakString("We have refunded your " + IntToString(nRefund) + " gold pieces, with a charge of " + IntToString(nCharge) + " for early cancellation.", TALKVOLUME_TALK);
        SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
        GiveGoldToCreature(oPC, nRefund);
        }
        if (nInvestment == 5)
        {
        int nOriginal = 1000;
        int nCharge = 100;
        int nRefund = (nOriginal - nCharge);
        SpeakString("We have refunded your " + IntToString(nRefund) + " gold pieces, with a charge of " + IntToString(nCharge) + " for early cancellation.", TALKVOLUME_TALK);
        SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
        GiveGoldToCreature(oPC, nRefund);
        }
    }
}
