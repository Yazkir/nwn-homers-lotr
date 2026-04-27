//::///////////////////////////////////////////////
//::ULTIMATE PC BUILDER V1
//::ALIGNMENT CHAOTIC 25
//:: CREATET BY BUTCHA(MoD)
//:://////////////////////////////////////////////
void main()
{

object oSpeaker = GetLastSpeaker();
object oCaster = OBJECT_SELF;
effect VFX1 = EffectVisualEffect(VFX_IMP_HEAD_MIND);
effect VFX2 = EffectVisualEffect(VFX_COM_HIT_ACID);
effect VFX3 = EffectVisualEffect(VFX_IMP_PULSE_NATURE);

DelayCommand(0.0, AssignCommand(oCaster, ActionCastFakeSpellAtObject(SPELL_NATURES_BALANCE,oSpeaker)));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX1,oSpeaker));
DelayCommand(2.3,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX2,oSpeaker));
DelayCommand(2.6,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX3,oSpeaker));
AdjustAlignment(oSpeaker, ALIGNMENT_CHAOTIC, 25);
DelayCommand(2.0,FloatingTextStringOnCreature("<c³*Œ>25 TO CHAOTIC",oSpeaker));
}







