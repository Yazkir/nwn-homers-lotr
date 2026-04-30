void main()
{
object oPC = GetPCSpeaker();
CreateItemOnObject ("greendragonsmall", oPC);
TakeGoldFromCreature (70, oPC, TRUE);
}
