int StartingConditional()
{
object oPC = GetPCSpeaker();
int nGold;

nGold = GetGold(oPC);

if (nGold > 199)
{
return TRUE;
}

return FALSE;


}
