// Paths of the Dead -- action when Aragorn sets the proving task: slay the
// Witch-king and return with proof. Persists per character across reboots.
void main()
{
    object oPC = GetPCSpeaker();
    SetCampaignInt("potd", "started", 1, oPC);
    SetCampaignInt("potd", "task", 1, oPC);
    AddJournalQuestEntry("paths_of_the_dead", 10, oPC, FALSE, FALSE);
}
