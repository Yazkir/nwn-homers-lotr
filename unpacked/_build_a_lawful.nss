//::///////////////////////////////////////////////
//::ULTIMATE PC BUILDER V1
//::ALIGNMENT Lawful 25
//:: CREATET BY BUTCHA(MoD)
//:://////////////////////////////////////////////
void main()
{

object oSpeaker = GetLastSpeaker();
object oCaster = OBJECT_SELF;
effect VFX1 = EffectVisualEffect(VFX_IMP_HEAD_FIRE);
effect VFX2 = EffectVisualEffect(VFX_COM_HIT_FIRE);
effect VFX3 = EffectVisualEffect(VFX_IMP_PULSE_FIRE);

DelayCommand(0.0, AssignCommand(oCaster, ActionCastFakeSpellAtObject(SPELL_FIREBALL,oSpeaker)));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX1,oSpeaker));
DelayCommand(2.3,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX2,oSpeaker));
DelayCommand(2.6,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX3,oSpeaker));
AdjustAlignment(oSpeaker, ALIGNMENT_LAWFUL, 25);
DelayCommand(2.0,FloatingTextStringOnCreature("<cãC>25 TO LAWFUL",oSpeaker));
}







