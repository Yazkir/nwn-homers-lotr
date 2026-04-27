void main()
{
object oPC  = GetLastAttacker();
effect Vfx1 = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
effect Dmg  = EffectDamage(9999);
if(GetLocalInt(OBJECT_SELF,"iRun")== TRUE)
{
FloatingTextStringOnCreature("Spawn Fix its running",oPC);
return;
}
else
{
SetLocalInt(OBJECT_SELF,"iRun",TRUE);
DelayCommand(6.0,SetLocalInt(OBJECT_SELF,"iRun",FALSE));
AssignCommand(OBJECT_SELF,ActionSpeakString("Stop you Fag!!",TALKVOLUME_TALK));
AssignCommand(OBJECT_SELF,ActionCastFakeSpellAtObject(SPELL_GREAT_THUNDERCLAP,oPC,PROJECTILE_PATH_TYPE_DEFAULT));
DelayCommand(2.3,ApplyEffectToObject(DURATION_TYPE_INSTANT,Vfx1,oPC));
DelayCommand(2.3,ApplyEffectToObject(DURATION_TYPE_INSTANT,Dmg,oPC));
}
}

