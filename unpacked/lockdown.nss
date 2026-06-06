void main()
{
    // Keep creatures in their spawn area (anti-kiting); see leash_to_area.nss.
    ExecuteScript("leash_to_area", OBJECT_SELF);


object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

CreateItemOnObject("jailed", oPC);

}

