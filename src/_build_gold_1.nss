//::///////////////////////////////////////////////
//::ULTIMATE PC BUILDER V1
//::ALIGNMENT GOLD 1000
//:: CREATET BY BUTCHA(MoD)
//:://////////////////////////////////////////////
void main ()
{
object oSpeaker = GetLastSpeaker();
object oCaster = OBJECT_SELF;
effect VFX1 = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
effect VFX2 = EffectVisualEffect(VFX_IMP_HEALING_G);
effect VFX3 = EffectVisualEffect(VFX_IMP_PULSE_HOLY);

DelayCommand(0.0, AssignCommand(oCaster, ActionCastFakeSpellAtObject(SPELL_INVISIBILITY,oSpeaker)));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX1,oSpeaker));
DelayCommand(2.3,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX2,oSpeaker));
DelayCommand(2.6,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX3,oSpeaker));
DelayCommand(2.0,FloatingTextStringOnCreature("<cî½>1000 GP",oSpeaker));
GiveGoldToCreature(GetPCSpeaker(), 1000);

}


