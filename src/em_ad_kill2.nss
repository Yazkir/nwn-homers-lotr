void main()
{
object oPC = GetPCSpeaker();
object oPlayer = GetFirstPC();
effect Light_1 = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
effect Light_2 = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
effect Light_3 = EffectVisualEffect(VFX_DUR_DEATH_ARMOR);
effect Link = EffectLinkEffects(Light_1,Light_3);
effect eDeath = EffectDeath(FALSE,FALSE);
while(GetIsObjectValid(oPlayer))
{
if((GetIsReactionTypeHostile(oPlayer,oPC)==TRUE)||
   (GetReputation(oPC,oPlayer)== 0)==TRUE)
{
SetPlotFlag(oPC,FALSE);
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,Link,oPlayer));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,Light_2,oPlayer));
DelayCommand(1.7,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oPlayer));
}
if((GetIsReactionTypeHostile(oPlayer,oPC)==FALSE)&&(GetReputation(oPC,oPlayer)== 0)==FALSE)
{
FloatingTextStringOnCreature("Set ya target dislike first",oPC);
}
oPlayer = GetNextPC();
}
}
