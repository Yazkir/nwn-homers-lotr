int StartingConditional()
{
object oPC = GetPCSpeaker();
int iFlag;
int iGP = 50000;
if(GetGold(oPC) >= iGP)
   {iFlag = 1;}
if(!(GetGold(oPC) >= iGP))
   {iFlag = 0;}
return iFlag;
}
