void main()
{
    object oAttacker = GetLastAttacker(OBJECT_SELF);
    effect eDmg = EffectDamage(20,DAMAGE_TYPE_DIVINE,DAMAGE_POWER_NORMAL);
    effect eVFX = EffectVisualEffect(VFX_COM_HIT_DIVINE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oAttacker,0.0);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oAttacker,0.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectBlindness(),oAttacker,15.0);
}
