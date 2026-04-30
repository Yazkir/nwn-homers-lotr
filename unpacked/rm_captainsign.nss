void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

FloatingTextStringOnCreature("Captains Hall, do not enter", oPC);

}

