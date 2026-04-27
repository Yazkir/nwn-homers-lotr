void main()
{
    effect eSpawn1 = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
    effect eSpawn2 = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
    effect eSpawn  = EffectLinkEffects(eSpawn1, eSpawn2);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpawn, GetLocation(OBJECT_SELF));

}
