#include "my_charfuncs"

void CreateShield(object oContainer, object oPC, int nMaxLevel)
{
    int nHD;
    int nRandom;
    string sItem;

    if(!GetIsPC(oPC) || (GetHitDice(oPC) > nMaxLevel))
        return;

    nHD = GetHitDice(oPC);

    if(nHD >= 0 && nHD <= 5)
    {
        nRandom = Random(0) +1;
        switch(nRandom)
        {

        }
    }
    else if(nHD >= 6 && nHD <= 10)
    {
        nRandom = Random(3) +1;
        switch(nRandom)
        {
            case 1: sItem = "sh_all_001"; break;
            case 2: sItem = "sh_all_002"; break;
            case 3: sItem = "sh_all_003"; break;
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
