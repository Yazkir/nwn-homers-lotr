void main()
{
object oPC = GetPCSpeaker();
CreateItemOnObject ("greendragonlarge", oPC);
TakeGoldFromCreature (200, oPC, TRUE);
}
