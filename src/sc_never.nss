int StartingConditional()
{
object oPC = GetPCSpeaker();

if (!(GetLocalInt(oPC, "poo") == 69)) return FALSE;

return TRUE;
}

