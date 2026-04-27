void main()
{
        object oPC = GetLastSpeaker();

        AdjustReputation(oPC, GetObjectByTag("Evilfaction"),1000);
        AdjustReputation(oPC, GetObjectByTag("Goodfaction"),-100);
        AdjustReputation(oPC, GetObjectByTag("Neutralfaction"),-100);
}
