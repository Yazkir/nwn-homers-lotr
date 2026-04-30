effect eEffect;
int nInt;
object oTarget;

void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetItemPossessedBy(oPC, "rm_snowstormkey")!= OBJECT_INVALID)
   {
   oTarget = oPC;

   nInt = GetObjectType(oTarget);

   eEffect = EffectVisualEffect(VFX_FNF_ICESTORM);

   if (nInt != OBJECT_TYPE_WAYPOINT)
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget));
   else
      DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(oTarget)));

   nInt = GetObjectType(oTarget);

   eEffect = EffectVisualEffect(VFX_IMP_HEALING_G);

   if (nInt != OBJECT_TYPE_WAYPOINT)
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget));
   else
      DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(oTarget)));

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_ABILITY_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_AC_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_ATTACK_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_BLINDNESS) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_CHARMED) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_CONFUSED) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_CURSE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_DAMAGE_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_DAZED) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_DEAF) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_DISEASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_DOMINATED) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_FRIGHTENED) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_MOVEMENT_SPEED_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_NEGATIVELEVEL) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_POISON) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_SAVING_THROW_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_SKILL_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_SLOW) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_SPELL_RESISTANCE_DECREASE) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_TURNED) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
      {
      if (GetEffectType(eEffect)==EFFECT_TYPE_VISUALEFFECT) RemoveEffect(oTarget, eEffect);
      eEffect = GetNextEffect(oTarget);
      }

   eEffect = EffectHeal(2000);

   eEffect = SupernaturalEffect(eEffect);

   DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget));

   }
}

