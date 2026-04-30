void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

FloatingTextStringOnCreature("Chest Room", oPC);

}

