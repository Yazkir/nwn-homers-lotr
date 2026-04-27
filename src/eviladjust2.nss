void main()
{
        object oPC = GetLastUsedBy();

        AdjustReputation(oPC, GetObjectByTag("goodfaction"),-100);
        AdjustReputation(oPC, GetObjectByTag("evilfaction"),1000);

}
