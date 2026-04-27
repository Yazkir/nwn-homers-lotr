void main()
{
 object oTarget = GetObjectByTag("Raitheen");
 location spawnLoc=GetLocation(oTarget);
 effect eVis=EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL);
 ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, spawnLoc);
 DestroyObject(oTarget);
}
