//::///////////////////////////////////////////////
//:: Name  WHEELER PRIZE AWARD
//::    this is called on the conversation for the wheel of fortune operator
//:://////////////////////////////////////////////
/*
  when last we left our heroic script, it generated custom tokens
  for the wheeler to speak about prizes, and set local variables
  about those prizes on the npc.
  in this chapter, we're going to pay out the prizes.
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//::   this swipes heavily from the slots script by steve hunter
//:://////////////////////////////////////////////

//-- local str: WHEELER  sPrize = prize name/type.
//-- local int: WHEELER payout = payout amount in gp.
//-- local int: WHEELER goodie = constant spell type
//-- blah blah beastie = polymorph type
//-- sPotionID = blueprint for potion creation
//-- sMPID = BAH! use sPotionID for these, too.


void main()
{
    object oPC = GetPCSpeaker();
    string sPC = GetName(oPC);
    object oWheeler = GetObjectByTag("WHEELER");
    object oBouncer = GetObjectByTag("Bouncer");
    string sPrize = GetLocalString(oWheeler, "sPrize");
    int payout = GetLocalInt(oWheeler, "payout");

//---DEBUGGING-------------------------

   int goodie = GetLocalInt(oWheeler, "goodie");
   int beastie = GetLocalInt(oWheeler, "beastie");
   string sPotionID = GetLocalString(oWheeler, "sPotionID");
//-- leave these in, it seems to work better
//------------------------------------------------

//-- step 1, if the payout is gold, just pay the fool.

   if (payout > 0 && payout < 10000)
    {
     GiveGoldToCreature(oPC, payout);
     PlaySound("it_coins");
     TakeGoldFromCreature(payout, oBouncer, FALSE);
    }
    else if (payout == 10000)
     {
     GiveGoldToCreature(oPC, payout);
     PlaySound("it_coins");
     AssignCommand(oWheeler, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
     AssignCommand(oWheeler, ActionSpeakString(sPC + " wins the jackpot!"));
     TakeGoldFromCreature(payout, oBouncer, FALSE);
     }


    //-- now if it is 0, there's special stuff.
    else
     {
       if (sPrize == "Lose")
        {
        PlayVoiceChat(VOICE_CHAT_LAUGH, oWheeler);
        }

        else if (sPrize == "Curse" || sPrize == "Magic")
        {
        int goodie = GetLocalInt(oWheeler, "goodie");
        ActionCastSpellAtObject(goodie, oPC, METAMAGIC_ANY, TRUE, 10, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }  //-- end curse/magic section

        else if (sPrize == "Booby Prize")
        {
           int beastie = GetLocalInt(oWheeler, "beastie");
           effect eZap = EffectPolymorph(beastie);

          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eZap, oPC, 600.0);

            string sBeastie;

            switch (beastie)
            {
             case POLYMORPH_TYPE_BADGER:
             sBeastie = "badgie";
             break;

             case POLYMORPH_TYPE_BOAR:
             sBeastie = "piggie";
             break;

             case POLYMORPH_TYPE_COW:
             sBeastie = "cow";
             break;

             case POLYMORPH_TYPE_IMP:
             sBeastie = "imp";
             break;

             case POLYMORPH_TYPE_PIXIE:
             sBeastie = "fairy";
             break;

             case POLYMORPH_TYPE_PENGUIN:
             sBeastie = "penguin";
             break;

             case POLYMORPH_TYPE_GIANT_SPIDER:
             sBeastie = "hairy spider";
             break;
            }
          AssignCommand(oWheeler, ActionSpeakString(sPC + " has won the Booby Prize!  What a cute little " + sBeastie + "!"));
        }  //-- end booby prize section

        else if (sPrize == "Potion" || sPrize == "Mystery Prize")
        {
          string sPotionID = GetLocalString(oWheeler, "sPotionID");

          CreateItemOnObject(sPotionID, oPC, 1);

        }  //-- end potion/object section
      }//-- end the Payout == 0 section


//-- at the end of everything, destroy the local variables on the wheeler

     DeleteLocalInt(oWheeler, "payout");
     DeleteLocalString(oWheeler, "sPrize");

     DeleteLocalInt(oWheeler, "goodie");
     DeleteLocalString(oWheeler, "sPotionID");
     DeleteLocalString(oWheeler, "beastie");


}
