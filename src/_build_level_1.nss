//::///////////////////////////////////////////////
//::ULTIMATE PC BUILDER V1
//::LEVEL 1
//:: CREATET BY BUTCHA(MoD)
//:://////////////////////////////////////////////

void main()
{
object oSpeaker = GetLastSpeaker();
object oCaster = OBJECT_SELF;
effect VFX1 = EffectVisualEffect(VFX_IMP_HARM);
DelayCommand(0.0, AssignCommand(oCaster, ActionCastFakeSpellAtObject(SPELL_POWER_WORD_KILL,oSpeaker)));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX1,oSpeaker));
DelayCommand(2.0,FloatingTextStringOnCreature("<cî½>LEVEL 1",oSpeaker));
SetXP(GetPCSpeaker(),0);
}


