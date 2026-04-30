void main()
{
        object oPC = GetLastSpeaker();

        AdjustReputation(oPC, GetObjectByTag("Goodfaction"),-100);
        AdjustReputation(oPC, GetObjectByTag("Evilfaction"),-100);
        AdjustReputation(oPC, GetObjectByTag("Neutralfaction"),1000);
}
