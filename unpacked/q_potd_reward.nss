// Paths of the Dead -- Aragorn grants a copy of Anduril (Flame of the West) in
// exchange for proof of the Witch-king's death. Hardened against exploits:
//  * re-checks the proof IN THIS SCRIPT (not just the dialogue condition), so a
//    player cannot drop the proof after passing the condition and keep both;
//  * once per unique character, persisting across server reboots (campaign DB);
//  * verifies the reward actually reached the player before consuming the proof.
void main()
{
    object oPC = GetPCSpeaker();

    // Already rewarded this character (honourably or by force)? Bail.
    if (GetCampaignInt("potd", "granted", oPC)) return;

    // Re-verify the proof is genuinely present now (anti drop-after-condition).
    object oProof = GetItemPossessedBy(oPC, "wk_proof");
    if (!GetIsObjectValid(oProof))
    {
        AssignCommand(OBJECT_SELF, ActionSpeakString(
            "You carry no proof of the deed. Return when the Witch-king has fallen."));
        return;
    }

    // Mark this acquisition as the honourable grant so the OnAcquireItem hook
    // (acquireditem_tag) does not also log the "took it by force" entry.
    SetLocalInt(oPC, "potd_honourable", 1);

    object oNew = CreateItemOnObject("glamhring2", oPC, 1);
    if (!GetIsObjectValid(oNew))
    {
        // Creation failed -- do NOT consume the proof or mark granted; let them retry.
        DeleteLocalInt(oPC, "potd_honourable");
        SendMessageToPC(oPC, "Something prevented the blade from being given. Try again.");
        return;
    }

    // Success: consume the proof, record the grant, advance the journal.
    DestroyObject(oProof);
    SetCampaignInt("potd", "granted", 1, oPC);
    AddJournalQuestEntry("paths_of_the_dead", 40, oPC, FALSE, FALSE);

    // If the pack was full the engine drops the item at the PC's feet -- tell them.
    if (!GetIsObjectValid(GetItemPossessedBy(oPC, "narsil")))
        SendMessageToPC(oPC, "Your pack was full -- the Flame of the West lies at your feet.");
}
