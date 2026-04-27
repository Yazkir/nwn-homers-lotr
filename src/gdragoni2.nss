int StartingConditional()
{
object oPC = GetPCSpeaker();
int nGold;

nGold = GetGold(oPC);

if (nGold > 69)
{
return TRUE;
}

return FALSE;


}
