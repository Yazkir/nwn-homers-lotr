void main()
{
object oPC = GetEnteringObject();
if (!GetIsPC(oPC)) return;

if (ReflexSave(oPC, 50)) {
FloatingTextStringOnCreature("Whoa! - Slow down there, almost fell!", oPC);
}
else {
FloatingTextStringOnCreature("Ouch, that hurts, huh.", oPC);
effect eEffect = EffectDamage(d20(9), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC);
AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 4.0));
}
}
