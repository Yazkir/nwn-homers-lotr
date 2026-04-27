void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

CreateItemOnObject("jailed", oPC);

}

