//::///////////////////////////////////////////////
//::ULTIMATE PC BUILDER V1
//::ALIGNMENT neutral 25
//:: CREATET BY BUTCHA(MoD)
//:://////////////////////////////////////////////
void main()
{

object oSpeaker = GetLastSpeaker();
object oCaster = OBJECT_SELF;
effect VFX1 = EffectVisualEffect(VFX_IMP_HEAD_COLD);
effect VFX2 = EffectVisualEffect(VFX_COM_HIT_FROST);
effect VFX3 = EffectVisualEffect(VFX_IMP_PULSE_COLD);

DelayCommand(0.0, AssignCommand(oCaster, ActionCastFakeSpellAtObject(SPELL_ICE_STORM,oSpeaker)));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX1,oSpeaker));
DelayCommand(2.3,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX2,oSpeaker));
DelayCommand(2.6,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX3,oSpeaker));
AdjustAlignment(oSpeaker, ALIGNMENT_NEUTRAL, 25);
DelayCommand(2.0,FloatingTextStringOnCreature("<cõ>25 TO NEUTRAL",oSpeaker));
}







