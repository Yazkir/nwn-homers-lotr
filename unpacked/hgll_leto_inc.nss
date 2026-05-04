// hgll_leto_inc — NWNX:EE port (was: NWNX2 Letoscript bridge)
//
// HGLL was originally written against the NWNX2 Letoscript plugin, which is
// not available for NWN:EE. This file replaces the Letoscript-based BIC
// rewrites with direct NWNX:EE Creature/Player calls. Mutations are
// in-memory and instant; NWNX_Player_SaveCharacter flushes to BIC.
//
// Public API:
//   void HGLL_AddSkillPoint     (object oPC, int iSkill);
//   void HGLL_AddFeat           (object oPC, int iFeat);
//   void HGLL_AddStatPoint      (object oPC, int nStat);
//   void HGLL_AddHitPoints      (object oPC, int nHP, int nLevel);
//   void HGLL_ModifySaves       (object oPC);
//   void HGLL_SetDocumentedLevel(object oPC, int level);
//   int  HGLL_GetDocumentedLevel(object oPC);
//   void HGLL_FlushChanges      (object oPC);
//
// Compatibility shims (return ""): AddSkillPoint, AddFeat, AddStatPoint,
//   AddHitPoints, ModifySaves, SetDocumentedLevel. These let pre-existing
//   `sLeto += AddX(...)` accumulation lines stay in place as harmless no-ops
//   while the call's *side effect* (the apply) is delivered via the matching
//   HGLL_* helper at the same callsite. The shim form is no longer the path
//   that mutates state.
//
// Compatibility shim: ApplyLetoScriptToPC ignores its string argument and
//   just flushes the character. No more BootPC / re-login round-trip.

#include "hgll_const_inc"
#include "nwnx_creature"
#include "nwnx_player"
#include "nwnx_object"

const string HGLL_LEVEL_VAR = "hgll_real_level";

//----------------------------- core: NWNX-backed -----------------------------//

void HGLL_FlushChanges(object oPC)
{
    // ExportSingleCharacter writes the in-memory PC state to disk.
    // For meaningful persistence across reconnects the server must run with
    // -servervault 1 (NWN_SERVERVAULT=1 in the container) so the canonical
    // BIC lives on the server. In localvault mode the client's stale BIC
    // will overwrite us at next login.
    ExportSingleCharacter(oPC);
}

void HGLL_SetDocumentedLevel(object oPC, int level)
{
    if (level < 0) return;
    NWNX_Object_SetInt(oPC, HGLL_LEVEL_VAR, level, TRUE);
}

int HGLL_GetDocumentedLevel(object oPC)
{
    return NWNX_Object_GetInt(oPC, HGLL_LEVEL_VAR);
}

void HGLL_AddStatPoint(object oPC, int nStat)
{
    int cur = NWNX_Creature_GetRawAbilityScore(oPC, nStat);
    NWNX_Creature_SetRawAbilityScore(oPC, nStat, cur + 1);
}

void HGLL_AddSkillPoint(object oPC, int iSkill)
{
    int cur = GetSkillRank(iSkill, oPC, TRUE);
    NWNX_Creature_SetSkillRank(oPC, iSkill, cur + 1);
    int lvl = GetHitDice(oPC);
    if (lvl < 1) lvl = 1;
    int curByLvl = NWNX_Creature_GetSkillRankByLevel(oPC, iSkill, lvl);
    NWNX_Creature_SetSkillRankByLevel(oPC, iSkill, curByLvl + 1, lvl);
}

void HGLL_ModifySaves(object oPC)
{
    NWNX_Creature_SetBaseSavingThrow(oPC, SAVING_THROW_FORT,
        NWNX_Creature_GetBaseSavingThrow(oPC, SAVING_THROW_FORT) + 1);
    NWNX_Creature_SetBaseSavingThrow(oPC, SAVING_THROW_REFLEX,
        NWNX_Creature_GetBaseSavingThrow(oPC, SAVING_THROW_REFLEX) + 1);
    NWNX_Creature_SetBaseSavingThrow(oPC, SAVING_THROW_WILL,
        NWNX_Creature_GetBaseSavingThrow(oPC, SAVING_THROW_WILL) + 1);
}

void HGLL_AddHitPoints(object oPC, int nHP, int nLevel)
{
    // Mirror the original "spread the HP across positions to dodge the 255
    // per-level rollover" trick. Pre-cap, deposit at level 1 (any low level
    // works); post-cap, deposit at level (nLevel-40) so we don't pile onto
    // any one slot.
    int slot = (nLevel < 41) ? 1 : (nLevel - 40);
    int cur = NWNX_Creature_GetMaxHitPointsByLevel(oPC, slot);
    NWNX_Creature_SetMaxHitPointsByLevel(oPC, slot, cur + nHP);
    SetCurrentHitPoints(oPC, GetCurrentHitPoints(oPC) + nHP);
}

void HGLL_AddFeat(object oPC, int iFeat)
{
    if (iFeat < 0) return;

    // Greater-ability feats (764..823) historically also bumped the matching
    // ability score by 1 in HGLL.
    if (iFeat > 763 && iFeat < 824)
    {
        int stat;
        if      (iFeat <= 773) stat = ABILITY_CHARISMA;
        else if (iFeat <= 783) stat = ABILITY_CONSTITUTION;
        else if (iFeat <= 793) stat = ABILITY_DEXTERITY;
        else if (iFeat <= 803) stat = ABILITY_INTELLIGENCE;
        else if (iFeat <= 813) stat = ABILITY_WISDOM;
        else                   stat = ABILITY_STRENGTH;
        HGLL_AddStatPoint(oPC, stat);
    }

    // Original recorded the feat at LvlStatList[0] so de-leveling wouldn't
    // strip it; AddFeatByLevel(..., 1) is the EE equivalent and persists
    // across stat refreshes.
    NWNX_Creature_AddFeatByLevel(oPC, iFeat, 1);
}

//----------------------------- compatibility shims ---------------------------//

// Old NWNX2 IPC pattern. Now a no-op — kept so `LetoScript(s)` calls compile.
string LetoScript(string script) { return ""; }

// Old "round-trip the BIC through Letoscript and re-login the player".
// Now: flush in-memory changes to disk and stay logged in.
void ApplyLetoScriptToPC(string Script, object oPC)
{
    HGLL_FlushChanges(oPC);
}

// Returned Letoscript fragments. The callers usually do
//     sLeto += AddX(...);
// which is now harmless; the side-effect is delivered by a HGLL_* call
// at the same site.
string AddStatPoint(int nStat)                  { return ""; }
string AddSkillPoint(int iSkill)                { return ""; }
string ModifySaves()                            { return ""; }
string AddHitPoints(int nHP, int nLevel)        { return ""; }
string AddFeat(int iFeat = -1)                  { return ""; }
string SetDocumentedLevel(int level = 1)        { return ""; }

// Used to be a string-mangling helper for building a path into the legacy
// "Documents/NWN/servervault/<player>/<char>.bic" — no longer needed
// because we don't poke the BIC by hand. Kept as a tolerated stub so any
// straggling reference still links.
string GetBicFileName(object oPC)
{
    string sChar, sBicName;
    string sPCName = GetStringLowerCase(GetName(oPC));
    int i, iNameLength = GetStringLength(sPCName);
    for (i = 0; i < iNameLength; i++) {
        sChar = GetSubString(sPCName, i, 1);
        if (TestStringAgainstPattern("(*a|*n|*w|'|-|_)", sChar)) {
            if (sChar != " ") sBicName += sChar;
        }
    }
    return GetStringLeft(sBicName, 16);
}
