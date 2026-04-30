void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetHitDice(oPC) < 40)
   return;

object oTarget;
location lTarget;
oTarget = GetWaypointByTag("Legendport");

lTarget = GetLocation(oTarget);

if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());

AssignCommand(oPC, ActionJumpToLocation(lTarget));

}
