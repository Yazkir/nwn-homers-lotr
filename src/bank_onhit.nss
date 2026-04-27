void main()
{
object oPC = GetLastAttacker(OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
}
