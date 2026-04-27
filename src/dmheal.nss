void main()
{
object oSpeaker  = GetLastSpeaker();
object oCaster = OBJECT_SELF;
effect VFX1 = EffectVisualEffect(VFX_IMP_HEALING_L);
effect VFX2 = EffectVisualEffect(VFX_IMP_HEALING_S);
effect VFX3 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
effect NEGATIV = GetFirstEffect(oSpeaker);
DelayCommand(0.0, AssignCommand(oCaster, ActionCastFakeSpellAtObject(SPELL_MASS_HEAL,oSpeaker)));
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX1, oSpeaker));
DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX2, oSpeaker));
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,VFX3, oSpeaker));
DelayCommand(1.0,FloatingTextStringOnCreature("<cî½>DM Healed",oSpeaker));
ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oSpeaker);
ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oSpeaker)), oSpeaker);
while(GetIsEffectValid(NEGATIV))
{
if(GetEffectType(NEGATIV) == EFFECT_TYPE_ABILITY_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_AC_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_ATTACK_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_DAMAGE_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_SKILL_DECREASE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_BLINDNESS ||
GetEffectType(NEGATIV) == EFFECT_TYPE_DEAF ||
GetEffectType(NEGATIV) == EFFECT_TYPE_PARALYZE ||
GetEffectType(NEGATIV) == EFFECT_TYPE_NEGATIVELEVEL)
{
RemoveEffect(oSpeaker, NEGATIV);
}
NEGATIV = GetNextEffect(oSpeaker);
}

}
