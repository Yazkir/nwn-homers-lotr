void main()
{
    object oAttacker = GetLastAttacker(OBJECT_SELF);
    effect eDmg = EffectDamage(10,DAMAGE_TYPE_DIVINE,DAMAGE_POWER_NORMAL);
    effect eVFX = EffectVisualEffect(VFX_COM_HIT_DIVINE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oAttacker,0.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oAttacker,0.0f);
}
