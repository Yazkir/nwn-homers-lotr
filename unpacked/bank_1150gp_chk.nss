int StartingConditional()
{
object oPC = GetPCSpeaker();
int iFlag;
int iGP = 1150;
if(GetGold(oPC) >= iGP)
   {iFlag = 1;}
if(!(GetGold(oPC) >= iGP))
   {iFlag = 0;}
return iFlag;
}
