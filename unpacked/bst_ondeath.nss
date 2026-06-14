// bst_ondeath — wrapped creature OnDeath: record the kill, then chain original.
//
// Installed by bst_install. Credits every PC that dealt damage to the creature
// (gathered by bst_ondamage). Solo = exactly one PC contributor; Party = more
// than one. Sends each contributor a combat-log confirmation, and for hard
// creatures (CR >= BST_SF_CR) broadcasts a server-first kill. Recording happens
// BEFORE chaining the original handler so respawn/cleanup can't drop the count.

#include "bst_db"

// Walk the master chain to the owning PC; returns OBJECT_INVALID if none is a PC.
object Bst_OwningPC(object o)
{
    while (GetIsObjectValid(GetMaster(o))) o = GetMaster(o);
    if (GetIsPC(o) && !GetIsDM(o)) return o;
    return OBJECT_INVALID;
}

void main()
{
    object oCre     = OBJECT_SELF;
    string sCan     = Bst_Canonical(GetResRef(oCre));
    float  fCR      = GetChallengeRating(oCre);
    string sCreName = GetName(oCre);

    // Count valid PC contributors recorded by bst_ondamage.
    int nN = GetLocalInt(oCre, "bst_ctrb_n");
    int i;
    int nValid = 0;
    for (i = 0; i < nN; i++)
    {
        object m = GetLocalObject(oCre, "bst_ctrb_" + IntToString(i));
        if (GetIsObjectValid(m) && GetIsPC(m) && !GetIsDM(m)) nValid++;
    }

    // No PC dealt damage (trap, DM, environmental) -> don't count; chain & exit.
    if (nValid == 0)
    {
        string sOrigNone = GetLocalString(oCre, "bst_orig_death");
        if (sOrigNone != "") ExecuteScript(sOrigNone, oCre);
        return;
    }

    int bParty = (nValid > 1);

    // Pick the slayer for the server-first record: prefer the killing blow's
    // owning PC, else the first valid contributor.
    object oSlayer = Bst_OwningPC(GetLastKiller());

    for (i = 0; i < nN; i++)
    {
        object m = GetLocalObject(oCre, "bst_ctrb_" + IntToString(i));
        if (!GetIsObjectValid(m) || !GetIsPC(m) || GetIsDM(m)) continue;
        if (!GetIsObjectValid(oSlayer)) oSlayer = m;

        string sUuid = GetObjectUUID(m);
        Bst_RecordKill(sUuid, GetPCPublicCDKey(m), GetName(m), sCan, bParty);

        int nTotal = Bst_GetTotal(sUuid, sCan);
        SendMessageToPC(m, "[Bestiary] You have slain " + IntToString(nTotal) + " "
            + sCreName + (bParty ? " (Party)." : " (Solo)."));
    }

    // Server-first broadcast for hard creatures.
    if (fCR >= BST_SF_CR && GetIsObjectValid(oSlayer)
        && Bst_RegisterServerFirst(sCan, fCR, GetObjectUUID(oSlayer),
                                   GetName(oSlayer), GetPCPublicCDKey(oSlayer)))
    {
        string sMsg = "[SERVER FIRST] " + GetName(oSlayer)
            + (bParty ? "'s party" : "") + " has slain " + sCreName
            + " (CR " + IntToString(FloatToInt(fCR))
            + ") for the first time on the server!";
        object oP = GetFirstPC();
        while (GetIsObjectValid(oP))
        {
            SendMessageToPC(oP, sMsg);
            oP = GetNextPC();
        }
    }

    // Chain the creature's original OnDeath handler, if any.
    string sOrig = GetLocalString(oCre, "bst_orig_death");
    if (sOrig != "") ExecuteScript(sOrig, oCre);
}
