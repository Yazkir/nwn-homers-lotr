location lTarget;
object oTarget;

// Clears the pulse flag after 60s of inactivity. nSession is compared
// against the current value so a newer attack cancels older timers.
void ClearPulseIfStale(object oPC, int nSession)
{
    if (GetLocalInt(oPC, "KHAMUL_SESSION") == nSession)
        DeleteLocalInt(oPC, "KHAMUL_PULSE");
}

void main()
{
    object oPC = GetLastDamager();
    int dmg = d20(3);
    effect eDamage = EffectDamage(dmg, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_FIVE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
    if (GetIsPC(oPC)) {
        SetLocalInt(oPC, "KHAMUL_PULSE", 1);
        int nSession = GetLocalInt(oPC, "KHAMUL_SESSION") + 1;
        SetLocalInt(oPC, "KHAMUL_SESSION", nSession);
        DelayCommand(60.0f, ClearPulseIfStale(oPC, nSession));
    }
}
