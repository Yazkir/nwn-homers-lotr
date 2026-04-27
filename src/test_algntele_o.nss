location lTarget;
object oTarget;
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
   {
   AssignCommand(oPC, ClearAllActions());

   oTarget = GetWaypointByTag("numenor");

   lTarget = GetLocation(oTarget);

   if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

   AssignCommand(oPC, ActionJumpToLocation(lTarget));

   }
else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
   {
   AssignCommand(oPC, ClearAllActions());

   oTarget = GetWaypointByTag("");

   lTarget = GetLocation(oTarget);

   if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

   AssignCommand(oPC, ActionJumpToLocation(lTarget));

   }
else
   {
   AssignCommand(oPC, ClearAllActions());

   oTarget = GetWaypointByTag("");

   lTarget = GetLocation(oTarget);

   if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

   AssignCommand(oPC, ActionJumpToLocation(lTarget));

   }

}



