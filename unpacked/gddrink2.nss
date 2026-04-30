void main()
{

object oPC = GetPCSpeaker();

FloatingTextStringOnCreature ("*You drink the contents of the bottle, and you immediately feel better*", oPC, TRUE);
ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectHeal(1000), oPC);
TakeGoldFromCreature (10, oPC, TRUE);
}
