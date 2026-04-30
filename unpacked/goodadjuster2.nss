void main()
{
        object oPC = GetLastUsedBy();

        AdjustReputation(oPC, GetObjectByTag("goodfaction"),1000);
        AdjustReputation(oPC, GetObjectByTag("evilfaction"),-100);

}
