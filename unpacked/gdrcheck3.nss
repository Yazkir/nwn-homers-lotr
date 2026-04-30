//aldaron 16042004

int StartingConditional()
{
object oPC = GetPCSpeaker();

int check = GetLocalInt (oPC, "gdreward");

if (check == 3)
 {
 return TRUE;
 }

return FALSE;

}
