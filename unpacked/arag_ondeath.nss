// Aragorn OnDeath. Preserves the default death behaviour, then -- if a player
// cut him down -- records the "took Anduril by force" path of the Paths of the
// Dead quest. Guarded by the shared per-character "granted" flag so it fires at
// most once and never alongside the honourable reward.
void main()
{
    ExecuteScript("x2_def_ondeath", OBJECT_SELF);

    object oPC = GetLastKiller();
    if (!GetIsPC(oPC)) oPC = GetLastDamager();
    if (!GetIsPC(oPC)) return;

    if (GetCampaignInt("potd", "granted", oPC) == 0)
    {
        SetCampaignInt("potd", "granted", 1, oPC);
        AddJournalQuestEntry("paths_of_the_dead", 30, oPC, FALSE, FALSE);
    }
}
