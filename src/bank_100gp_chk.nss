int StartingConditional()
{
object oPC = GetPCSpeaker();
int iFlag;
int iGP = 100;
if(GetLocalInt(oPC, "flag_1") == 1)
   {if(GetGold(oPC) >= iGP){iFlag = 1;}
    if(!(GetGold(oPC) >= iGP)){iFlag = 0;}}
if(GetLocalInt(oPC, "flag_1") == 2)
   {if(GetCampaignInt("bankdb", "bankgp", oPC) >= iGP){iFlag = 1;}
    if(!(GetCampaignInt("bankdb", "bankgp", oPC) >= iGP)){iFlag = 0;}}
return iFlag;}
