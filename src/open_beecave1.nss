void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

object oTarget;
oTarget = GetObjectByTag("breecavedoor1");

AssignCommand(oTarget, ActionOpenDoor(oTarget));

}

