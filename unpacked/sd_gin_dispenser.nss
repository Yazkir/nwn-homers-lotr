void main()
{
   object oPC = GetLastUsedBy();
   effect e1 = EffectVisualEffect(VFX_IMP_CHARM, FALSE);
   effect e2 = EffectVisualEffect(VFX_IMP_CONFUSION_S, FALSE);
   effect e3 = EffectVisualEffect(VFX_IMP_DAZED_S, FALSE);
   effect e4 = EffectVisualEffect(VFX_FNF_SMOKE_PUFF, FALSE);

   if (GetLocalInt(OBJECT_SELF, "SPAM_FLAG") == 1)
   {
      FloatingTextStringOnCreature("** The machine appears to be resetting! **", oPC, FALSE);
      return;
   }
   FloatingTextStringOnCreature("** The machine churns and churns and out pops a bottle in your hands! **", oPC, FALSE);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, e1, OBJECT_SELF, 0.0f);
   DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, e2, OBJECT_SELF, 0.0f));
   DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, e3, OBJECT_SELF, 0.0f));
   DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, e4, OBJECT_SELF, 0.0f));

   CreateItemOnObject("bubba_gin", oPC, 1);
   SetLocalInt(OBJECT_SELF, "SPAM_FLAG", 1);
   DelayCommand(3.0f, SetLocalInt(OBJECT_SELF, "SPAM_FLAG", 0));
}
