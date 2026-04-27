//::///////////////////////////////////////////////
//:: Name  WHEELER
//::    this is called on the conversation for the wheel of fortune operator
//:://////////////////////////////////////////////
/*
  1: take 100gp to play (make sure they don't stiff you)
  2: pick a random prize to land on. (note: the wheel is cheated to pay out lower prizes more often)
  3: if the prize includes a random goodie (or baddie), pick one of those
  4: if the random goodie/baddie includes magic, zap the pc
  NOTE: the zapping has to go on another script.
  set a local variable on the WHEELER to do it.
  5: go back to the conversation, announce/give prizes, play again, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//::   this swipes heavily from the slots script by steve hunter
//:://////////////////////////////////////////////

//-- custom tokens
//-- 90001 = Results token  USE sPrize
//-- 90002 = Win/lose/error token     set on each.



void main()
{
    object oPC = GetPCSpeaker();  //-- our pigeon
    object oWheeler = GetObjectByTag("WHEELER"); //-- the wheel operator
    object oBouncer = GetObjectByTag("Bouncer"); //-- he keeps the profits
    int bet = 500;                //-- 100 gp to play
    string sPrize = "If you get this, there's an error.";
    int payout = 0;
    int nRandom; //-- random numbers

//-- DEBUGGING----------------------
//   int goodie = 333999;
//   int beastie = 333999;
//   SetLocalString(oWheeler, "sPotionID", "nw_it_msmlmisc23");
//----------------------------------

    SetCustomToken(90001, "No joy. ");   //-- result preset


//-- step one: get the loot!

   if (GetGold(oPC) < bet) //No credit given!
    {
      SetCustomToken(90002, "You do not have enough gold to play with me, luv.  Come back when ye have some more.");
      return;
    }

    TakeGoldFromCreature(bet, oPC, FALSE);
    GiveGoldToCreature(oBouncer, FloatToInt(IntToFloat(bet)/3.0)); //-- 1/3 is profit



//-- Step 2: pick a prize
  //-- 2a: decide on a low or high option.

   int nHiLo = Random(100);
   int nPrize;

   if (nHiLo < 73)  //-- greater chance of a low prize
   {
     nPrize = Random(9);

     switch (nPrize)
     {
        case 0:  //-- first prize is:  LOSE
        sPrize = "Lose";
        payout = 0;
        break;

        case 1:  //-- second prize is: CURSE
        sPrize = "Curse";
        payout = 0;
        break;

        case 2:  //-- these are obvious, ain't they?
        sPrize = "Mystery Prize";
        payout = 0;
        break;

        case 3:
        sPrize = "Potion";
        payout = 0;
        break;

        case 4:
        sPrize = "50";
        payout = 50;
        break;

        case 5:
        sPrize = "100";
        payout = 100;
        break;

        case 6:
        sPrize = "200";
        payout = 200;
        break;

        case 7:
        sPrize = "500";
        payout = 500;
        break;

        case 8:
        sPrize = "1,000";
        payout = 1000;
        break;
      }
   }

   else //-- if HiLo indicates high prize
    {

       nPrize = Random(4);

       switch (nPrize)
       {
          case 0:
          sPrize = "Booby Prize";
          payout = 0;
          break;

          case 1:
          sPrize = "Magic";
          payout = 0;
          break;

          case 2:
          sPrize = "5,000";
          payout = 5000;
          break;

          case 3:
          sPrize = "JACKPOT";
          payout = 10000;
          break;
       }
    }

//-- step 4... reporting the outcome:

   SetCustomToken(90001, sPrize +"!     ");  //-- part one, what the wheel spot is

//-- step 3, version 2
//-- now we're going to send the payout and sPrize to the WHEELER

    SetLocalInt(oWheeler, "payout", payout);
    SetLocalString(oWheeler, "sPrize", sPrize);

//-- step 3, version 1, pick the random goodies
//-- step 3: if the payout isn't monetary, do the special stuff.

   if (payout == 0)
   {
      if (sPrize == "Lose")
      {
         SetCustomToken(90002, "Loser!  House wins.");
         return;
      }
      else if (sPrize == "Curse")
      {
         SetCustomToken(90002, "The Wheel bestows a Curse.");

         nRandom = Random(11);

         switch (nRandom)
         {
           case 0:
           SetLocalInt(oWheeler, "goodie", SPELL_BESTOW_CURSE);
           break;

           case 1:
           SetLocalInt(oWheeler, "goodie", SPELL_BLINDNESS_AND_DEAFNESS);
           break;

           case 2:
           SetLocalInt(oWheeler, "goodie", SPELL_CONFUSION);
           break;

           case 3:
           SetLocalInt(oWheeler, "goodie", SPELL_DAZE);
           break;

           case 4:
           SetLocalInt(oWheeler, "goodie", SPELL_ENERGY_DRAIN);
           break;

           case 5:
           SetLocalInt(oWheeler, "goodie", SPELL_FEAR);
           break;

           case 6:
           SetLocalInt(oWheeler, "goodie", SPELL_FEEBLEMIND);
           break;

           case 7:
           SetLocalInt(oWheeler, "goodie", SPELL_HARM);
           break;

           case 8:
           SetLocalInt(oWheeler, "goodie", SPELL_HOLD_PERSON);
           break;

           case 9:
           SetLocalInt(oWheeler, "goodie", SPELL_POISON);
           break;

           case 10:
           SetLocalInt(oWheeler, "goodie", SPELL_SCARE);
           break;
         }
      } //-- end Curse IF
      else if (sPrize == "Mystery Prize")
      {
         nHiLo = Random(100);  //-- these come in 2 sizes
         string sMP;  //-- to tell the pigeon what he won

         if (nHiLo < 70)  //-- greater chance of low prize
         {
           nRandom = Random(5);

           switch (nRandom)
           {
            case 0:
            sMP = "Sprig of Belladonna";
            SetLocalString(oWheeler, "sPotionID", "nw_it_msmlmisc23");
            break;

            case 1:
            sMP = "Clove of Garlic";
            SetLocalString(oWheeler, "sPotionID", "nw_it_msmlmisc24");
            break;

            case 2:
            sMP = "Garnet";
            SetLocalString(oWheeler, "sPotionID", "nw_it_gem011");
            break;

            case 3:
            sMP = "Copper Necklace";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mneck020");
            break;

            case 4:
            sMP = "Silver Ring";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mring022");
            break;

           }
         }
         else //-- higher mystery prizes
         {
           nRandom = Random(5);

           switch (nRandom)
           {
            case 0:
            sMP = "Gold Ring";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mring023");
            break;

            case 1:
            sMP = "Ruby";
            SetLocalString(oWheeler, "sPotionID", "nw_it_gem006");
            break;

            case 2:
            sMP = "Ring of Resistance";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mring031");
            break;

            case 3:
            sMP = "Ring of the Rogue";
            SetLocalString(oWheeler, "sPotionID", "nw_hen_gal1rw");
            break;

            case 4:
            sMP = "Scabbard of Blessing";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mmidmisc04");
            break;

           }
         }
          SetCustomToken(90002, "Your Mystery Prize is a " + sMP + ". ");
      }  //-- end Mystery Prize IF

      else if (sPrize == "Potion")
      {
         nHiLo = Random(100);  //-- good prize or cheap prize
         string sPotion;

         if (nHiLo < 70)  //-- cheap prizes
         {
           nRandom = Random(4);

           switch (nRandom)
           {
            case 0:
            sPotion = "Ale";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion021");
            break;

            case 1:
            sPotion = "Cure Light Wounds";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion001");
            break;

            case 2:
            sPotion = "Speed Potion";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion004");
            break;

            case 3:
            sPotion = "Dwarven Spirits";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion022");
            break;
           }
         }
         else  //-- good potion prizes
         {
           nRandom = Random(3);


           switch (nRandom)
           {
            case 0:
            sPotion = "Potion of Aid";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion016");
            break;

            case 1:
            sPotion = "Cure Serious Wounds";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion002");
            break;

            case 2:
            sPotion = "Invisibility Potion";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion008");
            break;

            case 3:
            sPotion = "Barkskin Potion";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion005");
            break;
           }

         }
        SetLocalString(oWheeler, "sPotion", sPotion);
        SetCustomToken(90002, "You win a Potion: " + sPotion + ".");

      } //-- end Potions IF

      else if (sPrize == "Booby Prize")
      {
         nRandom = Random(7);

         switch (nRandom)
         {
           case 0:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_BADGER);
           break;

           case 1:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_BOAR);
           break;

           case 2:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_COW);
           break;

           case 3:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_GIANT_SPIDER);
           break;

           case 4:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_IMP);
           break;

           case 5:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_PENGUIN);
           break;

           case 6:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_PIXIE);
           break;
          }

         SetCustomToken(90002, "You win the Booby Prize!");

      }//-- end Booby Prize IF

       else if (sPrize == "Magic")
       {
          nRandom = Random(12);
          switch (nRandom)
         {
           case 0:
           SetLocalInt(oWheeler, "goodie", SPELL_AID);
           break;

           case 1:
           SetLocalInt(oWheeler, "goodie", SPELL_AURA_OF_VITALITY);
           break;

           case 2:
           SetLocalInt(oWheeler, "goodie", SPELL_BLESS);
           break;

           case 3:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_BULLS_STRENGTH);
           break;

           case 4:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_CATS_GRACE);
           break;

           case 5:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_FOXS_CUNNING);
           break;

           case 6:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_EAGLE_SPLENDOR);
           break;

           case 7:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_OWLS_WISDOM);
           break;

           case 8:
           SetLocalInt(oWheeler, "goodie", SPELL_CLARITY);
           break;

           case 9:
           SetLocalInt(oWheeler, "goodie", SPELL_FREEDOM_OF_MOVEMENT);
           break;

           case 10:
           SetLocalInt(oWheeler, "goodie", SPELL_GHOSTLY_VISAGE);
           break;

           case 11:
           SetLocalInt(oWheeler, "goodie", SPELL_HASTE);
           break;
         }
         SetCustomToken(90002, "The Wheel casts a spell.");
       } //-- end Magic IF
   }  //-- end of payout = 0 IF

   else  //-- if the payout is NOT zero
   {
      if (payout == 10000)  //-- if it is the jackpot
      {
      SetCustomToken(90002, "Congratulations, you win ten thousand gold pieces!");
      // GiveGoldToCreature(oPC, payout);
      }
      else
      {
      SetCustomToken(90002, " You win " + sPrize + " gold pieces!");
      // GiveGoldToCreature(oPC, payout);
      }
   }
}


