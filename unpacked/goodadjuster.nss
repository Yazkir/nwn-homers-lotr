void main()
{
        object oPC = GetLastUsedBy();

        AdjustReputation(oPC, GetObjectByTag("Goodfaction"),1000);
        AdjustReputation(oPC, GetObjectByTag("Evilfaction"),-100);
        AdjustReputation(oPC, GetObjectByTag("Neutralfaction"),-100);
}
