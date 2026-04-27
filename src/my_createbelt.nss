#include "my_charfuncs"


void CreateBelt(object oContainer, object oPC, int nMaxLevel)
{
    int nHD;
    int nRandom;
    string sItem;

    if(!GetIsPC(oPC) || (GetHitDice(oPC) > nMaxLevel))
        return;

    nHD = GetHitDice(oPC);

    if(nHD >= 0 && nHD <= 5)
    {
        nRandom = Random(18) +1;
        switch(nRandom)
        {
            case 1: sItem = "be_all_001"; break;
            case 2: sItem = "be_all_002"; break;
            case 3: sItem = "be_all_003"; break;
            case 4: sItem = "be_wizard_001"; break;
            case 5: sItem = "be_wizard_002"; break;
            case 6: sItem = "be_wizard_003"; break;
            case 7: sItem = "be_sorc_001"; break;
            case 8: sItem = "be_sorc_002"; break;
            case 9: sItem = "be_sorc_003"; break;
            case 10: sItem = "be_rogue_001"; break;
            case 11: sItem = "be_rogue_002"; break;
            case 12: sItem = "be_rogue_003"; break;
            case 13: sItem = "be_fighter_001"; break;
            case 14: sItem = "be_fighter_002"; break;
            case 15: sItem = "be_fighter_003"; break;
            case 16: sItem = "be_cleric_001"; break;
            case 17: sItem = "be_cleric_002"; break;
            case 18: sItem = "be_cleric_003"; break;
        }
    }
    else if(nHD >= 6 && nHD <= 10)
    {
        nRandom = Random(3) +1;
        switch(nRandom)
        {
            case 1: sItem = "be_all_005"; break;
            case 2: sItem = "be_all_006"; break;
            case 3: sItem = "be_all_007"; break;
        }
    }
    else if(nHD >= 11 && nHD <= 15)
    {

    }
    else if(nHD >= 16 && nHD <= 20)
    {

    }

    CreateItemOnObject(sItem,oContainer,1);
}
