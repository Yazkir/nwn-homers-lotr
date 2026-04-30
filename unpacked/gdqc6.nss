//aldaron 16042004
int StartingConditional()
{
object oPC = GetPCSpeaker();

int gfgf = GetLocalInt (oPC, "gdquest");

if (gfgf==2)
{
return TRUE;
}

return FALSE;


}

