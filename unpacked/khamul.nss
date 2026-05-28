// Called when the delayed damage fires. Checks liveness so a PC who died
// before the hit lands doesn't take damage, and clears their pulse flag.
void PulseDamage(object oVictim, effect eDamage)
{
    if (!GetIsObjectValid(oVictim)) return;
    if (GetIsDead(oVictim)) {
        DeleteLocalInt(oVictim, "KHAMUL_PULSE");
        return;
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oVictim);
}

void main()
{
    int iRand = Random(20);
    string sWPFirst = "WP_KHAMUL";
    string sWPSecond = IntToString(iRand);
    string sMoveTo = sWPFirst+sWPSecond;
    object oMoveTo = GetWaypointByTag(sMoveTo);
    object oVictim = GetLastDamager();
    location lstart = GetLocation(OBJECT_SELF);
    location ltarget = GetLocation(oMoveTo);
    effect eVis = EffectVisualEffect(1);
    effect eVis1 = EffectVisualEffect(203);
    effect eVis2 = EffectVisualEffect(89);
    effect eVis3 = EffectVisualEffect(254);
    effect eDamage = EffectDamage(69,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_PLUS_FIVE);

    // Stop pulsing if the victim is not engaged (flag cleared on death)
    if (!GetIsObjectValid(oVictim) || !GetLocalInt(oVictim, "KHAMUL_PULSE"))
        return;
    if (GetIsDead(oVictim)) {
        DeleteLocalInt(oVictim, "KHAMUL_PULSE");
        return;
    }

    DelayCommand(0.0f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF,6.0)));
    DelayCommand(0.5f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, OBJECT_SELF,6.0)));
    DelayCommand(1.0f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, OBJECT_SELF,6.0)));
    DelayCommand(1.2f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis3, OBJECT_SELF,6.0)));
    DelayCommand(1.5f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oMoveTo,6.0)));
    DelayCommand(2.2f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, oMoveTo,6.0)));
    DelayCommand(2.5f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oMoveTo,6.0)));
    DelayCommand(2.7f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis3, oMoveTo,6.0)));
    DelayCommand(3.0f, PulseDamage(oVictim, eDamage));
    ActionJumpToObject(oMoveTo, TRUE);
    ActionAttack(oVictim, FALSE);
    DelayCommand(5.4f,(ClearAllActions()));
}
