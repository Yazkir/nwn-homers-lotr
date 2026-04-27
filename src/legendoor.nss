//Put this script OnUsed  Homer LOTR v3 June3
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetHitDice(oPC) < 40)
   return;

object oTarget;
oTarget = GetObjectByTag("Legendoor");

SetLocked(oTarget, FALSE);

AssignCommand(oTarget, ActionOpenDoor(oTarget));

}

