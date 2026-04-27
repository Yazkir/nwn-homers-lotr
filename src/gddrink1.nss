void main()
{

object oPC = GetPCSpeaker();

FloatingTextStringOnCreature ("*You drink the contents of the bottle, and you immediately feel relaxed*", oPC, TRUE);
TakeGoldFromCreature (10, oPC, TRUE);
ApplyEffectToObject (DURATION_TYPE_TEMPORARY, EffectSlow(), oPC, 120.0f);
ApplyEffectToObject (DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CONSTITUTION, 3), oPC, 120.0f);
ApplyEffectToObject (DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_DEXTERITY, 3), oPC, 120.0f);
ApplyEffectToObject (DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_WISDOM, 3), oPC, 120.0f);
ApplyEffectToObject (DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CHARISMA, 3), oPC, 120.0f);
ApplyEffectToObject (DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 3), oPC, 120.0f);
}
