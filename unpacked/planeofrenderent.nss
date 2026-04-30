void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

object oTarget;
location lTarget;
oTarget = GetWaypointByTag("WP_renderinside");
lTarget = GetLocation(oTarget);
effect eVFX = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 8.0));

if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

DelayCommand(4.9,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oPC));
DelayCommand (5.0, AssignCommand(oPC, ClearAllActions()));
DelayCommand (5.1, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

}
