void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

int rmDoOnce = GetLocalInt(oPC, GetTag(OBJECT_SELF));

if (rmDoOnce==TRUE) return;

SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);

FloatingTextStringOnCreature("Welcome to the ¤§nowStorm¤ Castle.", oPC);

object oTarget;
oTarget = oPC;

int nInt;
nInt = GetObjectType(oTarget);

effect eEffect;
eEffect = EffectVisualEffect(VFX_FNF_ICESTORM);

if (nInt != OBJECT_TYPE_WAYPOINT)
   DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget));
else
   DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(oTarget)));

}

