////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_payloan - This script allows      //
//  players to pay their loan, dependent  //
//  on which amount they wish to pay.     //
////////////////////////////////////////////
#include "kpb_dateinc"
void main()
{
object oPC = GetPCSpeaker();
int nPayment = GetCampaignInt("kpb_bank", "KPB_LOAN_PAY", oPC);
int nBalance = GetCampaignInt("kpb_bank", "KPB_LOAN_AMT", oPC);
int nGold = GetGold(oPC);

int nYear = GetCampaignInt("kpb_bank", "KPB_LOAN_YEAR", oPC);
int nMonth = GetCampaignInt("kpb_bank", "KPB_LOAN_MONTH", oPC);
int nDay = GetCampaignInt("kpb_bank", "KPB_LOAN_DAY", oPC);

int iMonth = GetCalendarMonth();
int iDay = GetCalendarDay();
int iYear = GetCalendarYear();

int nOldCredit = GetCampaignInt("kpb_bank", "KPB_CREDIT_AMT", oPC);
string sCurrentDate = GetCurrentDate();
string sLoanDate = GetDateString(nDay, nMonth, nYear);
int nTotalDays = GetDateDifference(sLoanDate, sCurrentDate, "days");
int nInterestA = GetCampaignInt("kpb_bank", "KPB_CREDIT_RATE", oPC);
int nInterestB = GetCampaignInt("kpb_bank", "KPB_GLO_INT");
int nInterest = nInterestA + nInterestB;
int nNewInterest = ((nInterest * nBalance)/100);
int nNewBalanceA = (nBalance + nNewInterest);
int nNewBalanceB = (nBalance + (nNewInterest * 2));
int nNewBalanceC = (nBalance + (nNewInterest * 3));
int nNewBalanceD = (nBalance + (nNewInterest * 4));
int nNewBalanceE = (nBalance + (nNewInterest * 5));
int nNewBalanceF = (nBalance + (nNewInterest * 8));
  if (nTotalDays == 0 && nGold >= nBalance && nBalance <= nPayment)
  {
  SpeakString("Very well.  Your account didn't acquire any interest.", TALKVOLUME_TALK);
  TakeGoldFromCreature(nBalance, oPC, TRUE);
  SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", 0, oPC);
  }
  if (nTotalDays >= 1 && nTotalDays <= 7 && nGold >= nPayment)
  {
  int nNewBalance = (nBalance + nNewInterest);
  int nAmount = (nNewBalance - nPayment);
    if (nPayment > nNewBalanceA)
    {
    SpeakString("You do not owe that much to the bank.  I will take the difference.", TALKVOLUME_TALK);
    TakeGoldFromCreature(nNewBalanceA, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", 0, oPC);
    }
    if (nPayment <= nNewBalanceA)
    {
    TakeGoldFromCreature(nPayment, oPC, TRUE);
    SpeakString("You have paid " + IntToString(nPayment) + " gold.  You now owe " + IntToString(nAmount) + " to the bank.", TALKVOLUME_TALK);
      if (nTotalDays >= 5)
      {
      SetCampaignInt("kpb_bank", "KPB_CREDIT_AMT", nInterest, oPC);
      }
    SetCampaignInt("kpb_bank", "KPB_LOAN_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_MONTH", iMonth, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_DAY", iDay, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", nAmount, oPC);
    }
  }
  if (nTotalDays >= 8 && nTotalDays <= 14 && nGold >= nPayment)
  {
  int nNewBalance = (nBalance + (nNewInterest * 2));
  int nAmount = (nNewBalance - nPayment);
    if (nPayment > nNewBalanceB)
    {
    SpeakString("You do not owe that much to the bank.  I will take the difference.", TALKVOLUME_TALK);
    TakeGoldFromCreature(nNewBalanceB, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", 0, oPC);
    }
    if (nPayment <= nNewBalanceB)
    {
    TakeGoldFromCreature(nPayment, oPC, TRUE);
    SpeakString("You have paid " + IntToString(nPayment) + " gold.  You now owe " + IntToString(nAmount) + " to the bank.", TALKVOLUME_TALK);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", nAmount, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_MONTH", iMonth, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_DAY", iDay, oPC);
    }
    if (nOldCredit > -10)
    {
    int nCreditDamage = nOldCredit - nTotalDays;
    SetCampaignInt("kpb_bank", "KPB_CREDIT_RATE", nCreditDamage, oPC);
    }
  }
  if (nTotalDays >= 15 && nTotalDays <= 21 && nGold >= nPayment)
  {
  int nNewBalance = (nBalance + (nNewInterest * 3));
  int nAmount = (nNewBalance - nPayment);
    if (nPayment > nNewBalanceC)
    {
    SpeakString("You do not owe that much to the bank.  I will take the difference.", TALKVOLUME_TALK);
    TakeGoldFromCreature(nNewBalanceC, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", 0, oPC);
    }
    if (nPayment < nNewBalanceC)
    {
    TakeGoldFromCreature(nPayment, oPC, TRUE);
    SpeakString("You have paid " + IntToString(nPayment) + " gold.  You now owe " + IntToString(nAmount) + " to the bank.", TALKVOLUME_TALK);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", nAmount, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_MONTH", iMonth, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_DAY", iDay, oPC);
    }
    if (nOldCredit > -10)
    {
    int nCreditDamage = nOldCredit - nTotalDays;
    SetCampaignInt("kpb_bank", "KPB_CREDIT_RATE", nCreditDamage, oPC);
    }
  }
  if (nTotalDays >= 22 && nTotalDays <= 28 && nGold >= nPayment)
  {
  int nNewBalance = (nBalance + (nNewInterest * 4));
  int nAmount = (nNewBalance - nPayment);
    if (nPayment > nNewBalanceD)
    {
    SpeakString("You do not owe that much to the bank.  I will take the difference.", TALKVOLUME_TALK);
    TakeGoldFromCreature(nNewBalanceD, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", 0, oPC);
    }
    if (nPayment <= nNewBalanceD)
    {
    TakeGoldFromCreature(nPayment, oPC, TRUE);
    SpeakString("You have paid " + IntToString(nPayment) + " gold.  You now owe " + IntToString(nAmount) + " to the bank.", TALKVOLUME_TALK);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", nAmount, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_MONTH", iMonth, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_DAY", iDay, oPC);
    }
    if (nOldCredit > -10)
    {
    int nCreditDamage = nOldCredit - nTotalDays;
    SetCampaignInt("kpb_bank", "KPB_CREDIT_RATE", nCreditDamage, oPC);
    }
  }
  if (nTotalDays >= 29 && nTotalDays <= 36 && nGold >= nPayment)
  {
  int nNewBalance = (nBalance + (nNewInterest * 5));
  int nAmount = (nNewBalance - nPayment);
    if (nPayment > nNewBalanceE)
    {
    SpeakString("You do not owe that much to the bank.  I will take the difference.", TALKVOLUME_TALK);
    TakeGoldFromCreature(nNewBalanceE, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", 0, oPC);
    }
    if (nPayment <= nNewBalanceE)
    {
    TakeGoldFromCreature(nPayment, oPC, TRUE);
    SpeakString("You have paid " + IntToString(nPayment) + " gold.  You now owe " + IntToString(nAmount) + " to the bank.", TALKVOLUME_TALK);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", nAmount, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_MONTH", iMonth, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_DAY", iDay, oPC);
    }
    if (nOldCredit > -10)
    {
    int nCreditDamage = nOldCredit - nTotalDays;
    SetCampaignInt("kpb_bank", "KPB_CREDIT_RATE", nCreditDamage, oPC);
    }
  }
  if (nTotalDays > 37 && nGold >= nPayment)
  {
  int nNewBalance = (nBalance + (nNewInterest * 8));
  int nAmount = (nNewBalance - nPayment);
    if (nPayment > nNewBalanceF)
    {
    SpeakString("You do not owe that much to the bank.  I will take the difference.", TALKVOLUME_TALK);
    TakeGoldFromCreature(nNewBalanceF, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", 0, oPC);
    }
    if (nPayment < nNewBalanceF)
    {
    TakeGoldFromCreature(nPayment, oPC, TRUE);
    SpeakString("You have paid " + IntToString(nPayment) + " gold.  You now owe " + IntToString(nAmount) + " to the bank.", TALKVOLUME_TALK);
    SetCampaignInt("kpb_bank", "KPB_LOAN_AMT", nAmount, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_YEAR", iYear, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_MONTH", iMonth, oPC);
    SetCampaignInt("kpb_bank", "KPB_LOAN_DAY", iDay, oPC);
    }
    if (nOldCredit > -10)
    {
    int nCreditDamage = nOldCredit - nTotalDays;
    SetCampaignInt("kpb_bank", "KPB_CREDIT_RATE", nCreditDamage, oPC);
    }
  }
if (nGold < nPayment)
    {
    SpeakString("Sorry, you do not have enough to pay " + IntToString(nPayment) + " gold to pay on this loan.", TALKVOLUME_TALK);
    }
}
