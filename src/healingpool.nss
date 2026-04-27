//Modified by Jehke - Should stun user temporarily to prevent spamming
void main()
{
object oPC = GetLastUsedBy();
effect eStun = EffectPetrify();

ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oPC, METAMAGIC_ANY, TRUE);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eStun,oPC,2.5f);
}
