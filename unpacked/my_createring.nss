#include "my_charfuncs"


void CreateRing(object oContainer, object oPC, int nMaxLevel)
{
    int nHD;
    int nRandom;
    string sItem;

    if(!GetIsPC(oPC) || (GetHitDice(oPC) > nMaxLevel))
        return;

    nHD = GetHitDice(oPC);

    if(nHD >= 0 && nHD <= 5)
    {
        nRandom = Random(8) +1;
        switch(nRandom)
        {
            case 1: sItem = "ri_all_001"; break;
            case 2: sItem = "ri_all_002"; break;
            case 3: sItem = "ri_wizard_001"; break;
            case 4: sItem = "ri_sorc_001"; break;
            case 5: sItem = "ri_rogue_001"; break;
            case 6: sItem = "ri_fighter_001"; break;
            case 7: sItem = "ri_cleric_001"; break;
            case 8: sItem = "nw_it_mring008"; break;
        }
    }
    else if(nHD >= 6 && nHD <= 10)
    {
        nRandom = Random(12) +1;
        switch(nRandom)
        {
            case 1: sItem = "nw_it_mring014"; break;
            case 2: sItem = "nw_it_mring018"; break;
            case 3: sItem = "nw_it_mring032"; break;
            case 4: sItem = "nw_it_mring012"; break;
            case 5: sItem = "nw_it_novel001"; break;
            case 6: sItem = "ri_all_004"; break;
            case 7: sItem = "ri_all_005"; break;
            case 8: sItem = "ri_all_006"; break;
            case 9: sItem = "ri_all_007"; break;
            case 10: sItem = "ri_all_008"; break;
            case 11: sItem = "ri_all_009"; break;
            case 12: sItem = "ri_all_010"; break;
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
