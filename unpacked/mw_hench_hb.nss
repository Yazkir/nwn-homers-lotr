//::///////////////////////////////////////////////
//:: mw_hench_hb -- shared heartbeat for MeaningWave guide henchmen.
//:: Delegates to nw_ch_ac1 for standard associate AI, then adds
//:: master-follow / despawn-on-master-lost (same model as hench_demon_hb).
//::
//:: Also runs an out-of-style safety net: any guide carrying the spell will
//:: auto-cast Stone-to-Flesh on a petrified party member, or Restoration on a
//:: party member suffering ability-score damage -- regardless of combat style,
//:: in or out of combat. Casters are granted 3 memorized charges of each
//:: (engine refreshes on rest; a fresh summon restores them too).
//:://////////////////////////////////////////////

int MW_HasPetrify(object o)
{
    effect e = GetFirstEffect(o);
    while (GetIsEffectValid(e))
    {
        if (GetEffectType(e) == EFFECT_TYPE_PETRIFY) return TRUE;
        e = GetNextEffect(o);
    }
    return FALSE;
}

int MW_HasAbilityDamage(object o)
{
    effect e = GetFirstEffect(o);
    while (GetIsEffectValid(e))
    {
        if (GetEffectType(e) == EFFECT_TYPE_ABILITY_DECREASE) return TRUE;
        e = GetNextEffect(o);
    }
    return FALSE;
}

// Scan the party (master + henchmen) and cure the first affliction found.
void MW_CureScan(object oMaster)
{
    // Don't keep re-queuing a cure while one is already in flight.
    if (GetCurrentAction(OBJECT_SELF) == ACTION_CASTSPELL) return;

    int bStone = (GetHasSpell(SPELL_STONE_TO_FLESH, OBJECT_SELF) > 0);
    int bRest  = (GetHasSpell(SPELL_RESTORATION,    OBJECT_SELF) > 0);
    if (!bStone && !bRest) return;

    int n;
    for (n = 0; n <= 5; n++)
    {
        object oM;
        if (n == 0) oM = oMaster;
        else        oM = GetHenchman(oMaster, n);

        if (n > 0 && !GetIsObjectValid(oM)) break; // henchmen slots are contiguous
        if (!GetIsObjectValid(oM) || oM == OBJECT_SELF) continue;
        if (GetIsDead(oM)) continue;
        if (GetArea(oM) != GetArea(OBJECT_SELF)) continue;

        if (bStone && MW_HasPetrify(oM))
        {
            ClearAllActions();
            ActionCastSpellAtObject(SPELL_STONE_TO_FLESH, oM);
            return;
        }
        if (bRest && MW_HasAbilityDamage(oM))
        {
            ClearAllActions();
            ActionCastSpellAtObject(SPELL_RESTORATION, oM);
            return;
        }
    }
}

void main()
{
    ExecuteScript("nw_ch_ac1", OBJECT_SELF);

    object oMaster = GetMaster();
    if (!GetIsObjectValid(oMaster))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisappear(), OBJECT_SELF);
        return;
    }
    if (GetArea(OBJECT_SELF) != GetArea(oMaster))
    {
        location lTarget = GetLocation(oMaster);
        AssignCommand(OBJECT_SELF, ClearAllActions());
        DelayCommand(0.1, AssignCommand(OBJECT_SELF, ActionJumpToLocation(lTarget)));
        return;
    }

    MW_CureScan(oMaster);
}
