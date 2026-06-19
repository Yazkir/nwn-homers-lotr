//:: mw_counter_inc -- shared Counterspell combat mode (MW_STYLE 3) for caster guides.
//:: Readies a counterspell against the nearest enemy spellcaster (or, failing
//:: that, the nearest foe). The guide's Spellcraft is boosted in MW_ScaleGuide
//:: so the counter actually lands. Falls through to standard AI when no foe is in
//:: sight so the guide isn't left idle.

void MW_CounterspellRound()
{
    object oNearest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
        OBJECT_SELF, 1, CREATURE_TYPE_IS_ALIVE, TRUE);

    // Prefer an enemy who can actually cast.
    object oFoe = oNearest;
    object oTarget = OBJECT_INVALID;
    int k = 1;
    while (GetIsObjectValid(oFoe))
    {
        if (GetLevelByClass(CLASS_TYPE_WIZARD,   oFoe) > 0 ||
            GetLevelByClass(CLASS_TYPE_SORCERER, oFoe) > 0 ||
            GetLevelByClass(CLASS_TYPE_CLERIC,   oFoe) > 0 ||
            GetLevelByClass(CLASS_TYPE_DRUID,    oFoe) > 0 ||
            GetLevelByClass(CLASS_TYPE_BARD,     oFoe) > 0)
        {
            oTarget = oFoe;
            break;
        }
        k++;
        oFoe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            OBJECT_SELF, k, CREATURE_TYPE_IS_ALIVE, TRUE);
    }
    if (!GetIsObjectValid(oTarget)) oTarget = oNearest;

    if (GetIsObjectValid(oTarget))
    {
        ClearAllActions();
        ActionCounterSpell(oTarget);
        return;
    }

    // Nothing to counter -- act normally.
    ExecuteScript("x2_def_endcombat", OBJECT_SELF);
}
