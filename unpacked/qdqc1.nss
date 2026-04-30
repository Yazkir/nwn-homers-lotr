int StartingConditional()
{
object oPC = GetPCSpeaker();

int gdquest = GetLocalInt (oPC, "gdquest");

if (gdquest==1)
{
return TRUE;
}

return FALSE;

}
