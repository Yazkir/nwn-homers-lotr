location lTarget;
object oTarget;

void main()
{
object oPC = GetLastDamager();
int dmg = d20(3);
effect eDamage = EffectDamage(dmg,DAMAGE_TYPE_NEGATIVE,DAMAGE_POWER_PLUS_FIVE);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC);

}
