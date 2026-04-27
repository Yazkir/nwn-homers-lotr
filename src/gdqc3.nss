//aldaron 16042004
int StartingConditional()
{
object oPC = GetPCSpeaker();

int gfgf = GetLocalInt (oPC, "gdquest");

if (gfgf==0)
{
return TRUE;
}

if (gfgf==1)
{
return TRUE;
}

return FALSE;


}
