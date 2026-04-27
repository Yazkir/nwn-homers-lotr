//::///////////////////////////////////////////////
//::ULTIMATE PC BUILDER V2
//::LEVEL 40 MAX
//:: CREATET BY BUTCHA(MoD)
//:://////////////////////////////////////////////

void main()
{
object oSpeaker = GetLastSpeaker();
object oCaster = OBJECT_SELF;
effect VFX1 = EffectVisualEffect(VFX_IMP_HASTE);
DelayCommand(0.0, AssignCommand(oCaster, ActionCastFakeSpellAtObject(SPELL_MASS_HEAL,oSpeaker)));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX1,oSpeaker));
DelayCommand(2.0,FloatingTextStringOnCreature("<cî½>LEVEL 40 MAXX",oSpeaker));
SetXP(GetPCSpeaker(),780000);
}
