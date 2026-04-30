//aldaron 16042004

int StartingConditional()
{
object oPC = GetPCSpeaker();

int check = GetLocalInt (oPC, "gdreward");

if (check == 2)
 {
 return TRUE;
 }

return FALSE;

}
