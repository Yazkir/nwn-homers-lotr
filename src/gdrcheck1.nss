//aldaron 16042004

int StartingConditional()
{
object oPC = GetPCSpeaker();

int check = GetLocalInt (oPC, "gdreward");

if (check == 1)
 {
 return TRUE;
 }

return FALSE;

}
