void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

int DoOnce = GetLocalInt(oPC, GetTag(OBJECT_SELF));

if (DoOnce==TRUE) return;

SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);

FloatingTextStringOnCreature("Join the discord at https://discord.gg/VpAtSpe", oPC);
FloatingTextStringOnCreature("View the Wiki at homerslotrwiki.ddns.net  or  homers-lotr-wiki.jamesprice-slightlyepic.workers.dev", oPC);

}
