void hit(object oTarget)
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_COM_HIT_FIRE),oTarget);
DelayCommand(1.5,hit(OBJECT_SELF));
}

void main()
{
    // Record spawn area so the creature can be leashed to it (see leash_to_area.nss).
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));

    // Bestiary kill-tracking: install the OnDamaged/OnDeath wrappers (idempotent).
    ExecuteScript("bst_install", OBJECT_SELF);

DelayCommand(1.5,hit(OBJECT_SELF));
}
