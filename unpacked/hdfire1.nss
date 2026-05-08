void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

object oCaster;
oCaster = OBJECT_SELF;

object oTarget;
oTarget = GetObjectByTag("hdfire1");

AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_DELAYED_BLAST_FIREBALL, GetLocation(oTarget), METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));

}
