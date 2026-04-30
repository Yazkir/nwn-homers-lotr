////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_inv_assess - This script allows   //
//  players to assess their investment    //
//  that they have made with the Broker.  //
////////////////////////////////////////////
#include "kpb_dateinc"

void main()
{
  object oPC = GetPCSpeaker();
  int nYear = GetCampaignInt("kpb_bank", "KPB_INVEST_YEAR", oPC);
  int nMonth = GetCampaignInt("kpb_bank", "KPB_INVEST_MONTH", oPC);
  int nDay = GetCampaignInt("kpb_bank", "KPB_INVEST_DAY", oPC);

  int iMonth = GetCalendarMonth();
  int iDay = GetCalendarDay();
  int iYear = GetCalendarYear();

  string sCurrentDate = GetCurrentDate();
  string sDepDate = GetDateString(nDay, nMonth, nYear);
  int nTotalDays = GetDateDifference(sDepDate, sCurrentDate, "days");

  int nInvestment = GetCampaignInt("kpb_bank", "KPB_INVEST_TYPE", oPC);
  int nInvested = GetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", oPC);

if (nInvested == 1 && nTotalDays < 1)
    {
    SpeakString("You must give us a little more time.  You must wait one day from the time you invested to see the results!", TALKVOLUME_TALK);
    return;
    }

if (nInvested != 1)
    {
    SpeakString("Our records do not show you having any pending investments.", TALKVOLUME_TALK);
    SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
    return;
    }

if (nInvested == 1 && nTotalDays >= 1)
    {
        if (nInvestment == 1)
        {
        int nOriginal = 100;
        int nChance = d20(1);
            if (nChance == 1)
            {
            int nReturn = 80;
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The farming tools we invested in did not help the farmers at all!  Your return is less than your investment.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 2 && nChance <= 10)
            {
            int nReturn = 100 + (d10(1));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The new planting techniques we trained the farmers in has proven helpful!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 11 && nChance <= 19)
            {
            int nReturn = 100 + (d20(1));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The investment towards a new plow horse has helped more than we expected!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance == 20)
            {
            int nReturn = 100 + (d10(2)) + (d8(1));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The extra pay for the farm hands really paid off, more than we could ever have dreamed!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
        }
        if (nInvestment == 2)
        {
        int nOriginal = 5000;
        int nChance = (d100(1));
            if (nChance == 1)
            {
            SpeakString("The ship we invested in encountered pirates!  We have lost the ship, the crew, its cargo... and your gold.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 2 && nChance <= 5)
            {
            int nReturn = 5000 - (d100(20));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The ship we invested in encountered a storm!  It was forced to sell most of its goods at wholesale to pay for repairs. Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 6 && nChance <= 15)
            {
            int nReturn = 5000 - (d20(10));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("A strange market price change for our ship's goods happened before the ship arrived.  It was forced to sell its goods for cheaper than we bought them for. Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 16 && nChance <= 30)
            {
            int nReturn = 5000 + (d20(1));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The market price was decent, but not what we hoped for.  At least the ship made a profit.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 31 && nChance <= 60)
            {
            int nReturn = 5000 + (d20(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The market price was better than average, but not what we hoped for.  At least the ship made a profit.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 61 && nChance <= 80)
            {
            int nReturn = 5040 + (d100(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The market price was quite nice.  The ship made quite a good profit from its goods.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 81 && nChance <= 95)
            {
            int nReturn = 5200 + (d100(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The market price actually increased on the goods we shipped before our ship got to port!  The trade route made a hefty profit!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 96 && nChance <= 99)
            {
            int nReturn = 5400 + (d100(3));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The port ran out of quality goods, just in time for our shipment!  The trade route was extremely prosperous!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance == 100)
            {
            int nReturn = 5500 + (d100(5));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("Our ship ran into a storm on its journey, but it discovered a new land!  The Crown has paid an additional ransom for our sea charts to establish trade!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
        }
        if (nInvestment == 3)
        {
        int nOriginal = 2500;
        int nChance = (d100(1));
            if (nChance >= 1 && nChance <= 5)
            {
            SpeakString("The new market structure came crashing down due to faulty building.  There was no money left after rebuilding it and paying for the healers.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 6 && nChance <= 15)
            {
            int nReturn = 2500 - (d100(1));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The new marketplace was not deemed very special by customers, so opening day did not pay off too well.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 16 && nChance <= 25)
            {
            int nReturn = 2500 + (d20(1));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The new marketplace sparked some customer interest.  At least there was a profit.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 26 && nChance <= 55)
            {
            int nReturn = 2500 + (d20(5));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The new marketplace gathered a decent amount of new customers and brought some old customers back.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 56 && nChance <= 85)
            {
            int nReturn = 2600 + (d20(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The marketplace was revitalized, and all the customers were eager to spend!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 86 && nChance <= 95)
            {
            int nReturn = 2650 + (d20(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The marketplace is breathing new life into the whole city!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 96 && nChance <= 100)
            {
            int nReturn = 2700 + (d20(3));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("They are speaking of our marketplace in other, distant lands because it is so great now!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
        }

        if (nInvestment == 4)
        {
        int nOriginal = 3000;
        int nChance = (d100(1));
            if (nChance >= 1 && nChance <= 15)
            {
            SpeakString("We actually cannot find the merchant we invested in... we believe he skipped town, with you gold.  We will inform the guards, but there is no hope.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 16 && nChance <= 30)
            {
            int nReturn = 3000 - (d100(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The shop we invested in spent the money on expensive stained-glass windows.  Although beautiful, customers could not see through them to the goods inside the store.  We had a loss.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 31 && nChance <= 50)
            {
            int nReturn = 3000 + ((d20(2)) - (d20(2)));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The improvement was taken indifferently by passersby.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 51 && nChance <= 75)
            {
            int nReturn = 3050 + (d100(1));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The improvement seemed to draw the eyes of shoppers slightly.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 76 && nChance <= 90)
            {
            int nReturn = 3100 + (d100(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The shop was very lively and full of customers, thanks to an improvement in inventory placement!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 91 && nChance <= 99)
            {
            int nReturn = 3200 + (d100(3));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The shop's new style and gold management has lead to record profits!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance == 100)
            {
            int nReturn = 5500 + (d100(5));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The shop did so well, it doubled its sales!  The shopkeeper has decided to move to a larger city, and now he can afford it!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
        }


        if (nInvestment == 5)
        {
        int nOriginal = 3000;
        int nChance = (d100(1));
            if (nChance >= 1 && nChance <= 10)
            {
            SpeakString("The snobby little gnome we invested in used the gold to build something diabolical, sold it to the Drow, and we have not seen him since!  We have lost the investments!", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 11 && nChance <= 20)
            {
            SpeakString("The lead wizard working on the project we invested in killed over at the ripe old age of 124.  Unfortunately, he coded all of his work in a way only he could understand, so we lost the investment!  Paranoid old fool...", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 21 && nChance <= 30)
            {
            SpeakString("Wilhelm Shakesbeare came out with a few new poems and stories, but the only thing they were good for was to keep the bonfire going in front of his house.  What a waste of gold!", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 31 && nChance <= 40)
            {
            SpeakString("We received a report from the researches that Beholder Juice, a new type of home brew, caused most of the test subjects to explode or go insane.  If they had only told us the TOPIC of the project...", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 41 && nChance <= 50)
            {
            int nReturn = 1000 - (d100(2));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("Well, the local think-tank came up with a new way to engineer clocks.  Unfortunately, it was an exact copy of Billigard Greenfoot's gears.  We had to pay him royalties to sell it.  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 51 && nChance <= 75)
            {
            int nReturn = 1000 - (d20(5));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The genius Christof Columbo finished his experiments and revealed today that the world is round.  Unfortunately, the Crown rejected the theory, and we lost gold.  Of all people, you would think a genius would know the TRUE shape of the world... Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 76 && nChance <= 85)
            {
            int nReturn = 1000 + (d20(10));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("By dipping iron into a new solution, rather than water, it was discovered it could be strengthened and preserved longer!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 86 && nChance <= 90)
            {
            int nReturn = 1000 + (d100(5));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("A new form of copying paper has been discovered: a more durable scribe's pen!  Clerics and Monks everywhere have bought one!  Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 91 && nChance <= 94)
            {
            int nReturn = 1500 + (d100(5));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("The genius Herman Treffpunkt has originated a whole series of textbooks for teaching Common to Commoners!   Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 95 && nChance <= 98)
            {
            int nReturn = 1900 + (d100(5));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("Our inventors have created a crystal which allows for long-distance communication!  The Crown wants to buy up the new invention!   Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
            if (nChance >= 99 && nChance <= 100)
            {
            int nReturn = 2100 + (d100(10));
            GiveGoldToCreature(oPC, nReturn);
            SpeakString("Our inventors have created a flying machine capable of moving people and goods over great distances!  The Crown has bought the prototype for testing!   Here is your " + IntToString(nReturn) + " gold pieces.", TALKVOLUME_TALK);
            SetCampaignInt("kpb_bank", "KPB_BROKER_TOGGLE", 0, oPC);
            }
        }
    }
}
