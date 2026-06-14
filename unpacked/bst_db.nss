// bst_db.nss — Bestiary / creature-kill-tracking database helpers
//
// Campaign DB: "bestiarydb" (SQLite, file database/bestiary.sqlite3)
//
// Tables:
//   kills        (uuid, cdkey, char_name, resref, solo_kills, party_kills, last_kill)
//                  PRIMARY KEY (uuid, resref) — per-character per-creature totals.
//                  Character identity is GetObjectUUID (persists in the .bic);
//                  cdkey kept so per-(character,cdkey) aggregation is possible.
//   server_first (resref PK, cr, first_uuid, first_name, first_cdkey, first_at)
//                  one row per hard creature (CR >= BST_SF_CR) first slain server-wide.
//   catalogue    (resref PK, name, cr) — every creature type, seeded by nwn-wiki.
//   resref_alias (resref PK, canonical) — maps blueprint/variant resrefs to the
//                  canonical resref used everywhere else, also seeded by nwn-wiki.
//
// Kills are recorded by CANONICAL resref (see Bst_Canonical) so the in-game
// bestiary, the per-creature confirmation, and the wiki stats all agree.

const string BST_DB    = "bestiarydb";
const float  BST_SF_CR = 60.0;   // "Server First" threshold (Challenge Rating)

// ------------------------------------------------------------
// Schema

void Bst_InitDb()
{
    sqlquery q;

    q = SqlPrepareQueryCampaign(BST_DB,
        "CREATE TABLE IF NOT EXISTS kills (" +
        "uuid TEXT NOT NULL," +
        "cdkey TEXT NOT NULL," +
        "char_name TEXT," +
        "resref TEXT NOT NULL," +
        "solo_kills INTEGER NOT NULL DEFAULT 0," +
        "party_kills INTEGER NOT NULL DEFAULT 0," +
        "last_kill TEXT," +
        "PRIMARY KEY (uuid, resref))");
    SqlStep(q);

    q = SqlPrepareQueryCampaign(BST_DB,
        "CREATE INDEX IF NOT EXISTS idx_kills_resref ON kills(resref)");
    SqlStep(q);

    q = SqlPrepareQueryCampaign(BST_DB,
        "CREATE TABLE IF NOT EXISTS server_first (" +
        "resref TEXT PRIMARY KEY," +
        "cr REAL," +
        "first_uuid TEXT," +
        "first_name TEXT," +
        "first_cdkey TEXT," +
        "first_at TEXT NOT NULL DEFAULT (datetime('now')))");
    SqlStep(q);

    q = SqlPrepareQueryCampaign(BST_DB,
        "CREATE TABLE IF NOT EXISTS catalogue (" +
        "resref TEXT PRIMARY KEY, name TEXT, cr REAL)");
    SqlStep(q);

    q = SqlPrepareQueryCampaign(BST_DB,
        "CREATE TABLE IF NOT EXISTS resref_alias (" +
        "resref TEXT PRIMARY KEY, canonical TEXT NOT NULL)");
    SqlStep(q);
}

// ------------------------------------------------------------
// Recording

// Resolve an instance/blueprint resref to its canonical resref. Falls back to
// the input when no alias row exists (e.g. catalogue not yet seeded).
string Bst_Canonical(string sResref)
{
    sqlquery q = SqlPrepareQueryCampaign(BST_DB,
        "SELECT canonical FROM resref_alias WHERE resref=@r");
    SqlBindString(q, "@r", sResref);
    if (SqlStep(q)) return SqlGetString(q, 0);
    return sResref;
}

// Add one kill of sResref (already canonical) to a character's record.
// bParty TRUE -> party kill, FALSE -> solo kill.
void Bst_RecordKill(string sUuid, string sCdkey, string sName, string sResref, int bParty)
{
    sqlquery q = SqlPrepareQueryCampaign(BST_DB,
        "INSERT INTO kills(uuid,cdkey,char_name,resref,solo_kills,party_kills,last_kill)" +
        " VALUES(@u,@k,@n,@r,@s,@p,datetime('now'))" +
        " ON CONFLICT(uuid,resref) DO UPDATE SET" +
        " solo_kills=solo_kills+@s," +
        " party_kills=party_kills+@p," +
        " cdkey=excluded.cdkey," +
        " char_name=excluded.char_name," +
        " last_kill=excluded.last_kill");
    SqlBindString(q, "@u", sUuid);
    SqlBindString(q, "@k", sCdkey);
    SqlBindString(q, "@n", sName);
    SqlBindString(q, "@r", sResref);
    SqlBindInt(q, "@s", bParty ? 0 : 1);
    SqlBindInt(q, "@p", bParty ? 1 : 0);
    SqlStep(q);
}

// Total kills (solo+party) of sResref by a character — for the combat-log line.
int Bst_GetTotal(string sUuid, string sResref)
{
    sqlquery q = SqlPrepareQueryCampaign(BST_DB,
        "SELECT solo_kills + party_kills FROM kills WHERE uuid=@u AND resref=@r");
    SqlBindString(q, "@u", sUuid);
    SqlBindString(q, "@r", sResref);
    if (SqlStep(q)) return SqlGetInt(q, 0);
    return 0;
}

// Register the first server-wide kill of a hard creature. Returns TRUE only when
// this call created the row (i.e. it really was the server first).
int Bst_RegisterServerFirst(string sResref, float fCR, string sUuid, string sName, string sCdkey)
{
    sqlquery qc = SqlPrepareQueryCampaign(BST_DB,
        "SELECT 1 FROM server_first WHERE resref=@r");
    SqlBindString(qc, "@r", sResref);
    if (SqlStep(qc)) return FALSE;       // already recorded

    sqlquery q = SqlPrepareQueryCampaign(BST_DB,
        "INSERT INTO server_first(resref,cr,first_uuid,first_name,first_cdkey)" +
        " VALUES(@r,@c,@u,@n,@k) ON CONFLICT(resref) DO NOTHING");
    SqlBindString(q, "@r", sResref);
    SqlBindFloat (q, "@c", fCR);
    SqlBindString(q, "@u", sUuid);
    SqlBindString(q, "@n", sName);
    SqlBindString(q, "@k", sCdkey);
    SqlStep(q);
    return TRUE;
}

// ------------------------------------------------------------
// In-game bestiary menu (book conversation). Tokens 5030-5041.
//   local int    "bst_mode"       0 = Creatures Slain, 1 = Not Yet Slain
//   local int    "bst_page_off"   row offset (multiples of 9)
//   local int    "bst_page_total" total rows in the section (set here)
//   local string "bst_slot_N_resref" canonical resref shown in slot N
// Mirrors Merit_BuildPage in merit_db.nss.

void Bst_BuildPage(object oPC)
{
    int    nMode = GetLocalInt(oPC, "bst_mode");
    int    nOff  = GetLocalInt(oPC, "bst_page_off");
    string sUuid = GetObjectUUID(oPC);

    // Section row count (for pagination + [Next >>] visibility).
    sqlquery qc;
    if (nMode == 0)
        qc = SqlPrepareQueryCampaign(BST_DB,
            "SELECT COUNT(*) FROM catalogue c" +
            " JOIN kills k ON k.resref=c.resref WHERE k.uuid=@u");
    else
        qc = SqlPrepareQueryCampaign(BST_DB,
            "SELECT COUNT(*) FROM catalogue c" +
            " WHERE c.resref NOT IN (SELECT resref FROM kills WHERE uuid=@u)");
    SqlBindString(qc, "@u", sUuid);
    int nTotal = 0;
    if (SqlStep(qc)) nTotal = SqlGetInt(qc, 0);
    SetLocalInt(oPC, "bst_page_total", nTotal);

    int nPages = (nTotal + 8) / 9;
    if (nPages == 0) nPages = 1;
    int nPage = nOff / 9 + 1;
    SetCustomToken(5040, nMode == 0 ? "Creatures Slain" : "Not Yet Slain");
    SetCustomToken(5041, "Page " + IntToString(nPage) + " of " + IntToString(nPages));

    int i;
    for (i = 0; i < 9; i++)
    {
        DeleteLocalString(oPC, "bst_slot_" + IntToString(i) + "_resref");
        SetCustomToken(5030 + i, "");
    }

    sqlquery q;
    if (nMode == 0)
        q = SqlPrepareQueryCampaign(BST_DB,
            "SELECT c.resref, c.name, c.cr, k.solo_kills, k.party_kills" +
            " FROM catalogue c JOIN kills k ON k.resref=c.resref" +
            " WHERE k.uuid=@u ORDER BY c.cr DESC, c.name ASC LIMIT 9 OFFSET @off");
    else
        q = SqlPrepareQueryCampaign(BST_DB,
            "SELECT c.resref, c.name, c.cr" +
            " FROM catalogue c WHERE c.resref NOT IN (SELECT resref FROM kills WHERE uuid=@u)" +
            " ORDER BY c.cr DESC, c.name ASC LIMIT 9 OFFSET @off");
    SqlBindString(q, "@u", sUuid);
    SqlBindInt(q, "@off", nOff);

    i = 0;
    while (SqlStep(q) && i < 9)
    {
        string sResref = SqlGetString(q, 0);
        string sName   = SqlGetString(q, 1);
        int    nCR     = FloatToInt(SqlGetFloat(q, 2));

        SetLocalString(oPC, "bst_slot_" + IntToString(i) + "_resref", sResref);

        string sLabel;
        if (nMode == 0)
            sLabel = sName + "  (CR " + IntToString(nCR) + ")  [Solo:"
                   + IntToString(SqlGetInt(q, 3)) + " Party:"
                   + IntToString(SqlGetInt(q, 4)) + "]";
        else
            sLabel = sName + "  (CR " + IntToString(nCR) + ")";

        SetCustomToken(5030 + i, sLabel);
        i++;
    }
}
