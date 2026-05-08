void ApplyPenalty(object oDead)
{
    int nXP = GetXP(oDead);
    int nPenalty = 0 * GetHitDice(oDead);
    int nHD = GetHitDice(oDead);
    // * You can not lose a level with this respawning
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    int nNewXP = nXP - nPenalty;
    if (nNewXP < nMin)
       nNewXP = nMin;
    SetXP(oDead, nNewXP);
    int nGoldToTake =    FloatToInt(0.10 * GetGold(oDead));
    // * a cap of 0gp taken from you
    if (nGoldToTake > 00000000)
    {
        nGoldToTake = 00000000;
    }
    AssignCommand(oDead, TakeGoldFromCreature(nGoldToTake, oDead, TRUE));
//    DelayCommand(4.0, FloatingTextStrRefOnCreature(58299, oDead, FALSE));
//    DelayCommand(4.8, FloatingTextStrRefOnCreature(58300, oDead, FALSE));

    // * Note: waiting for Sophia to make SetStandardFactionReptuation to clear all personal reputation
    if (GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oDead) <= 10)
    {   SetLocalInt(oDead, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oDead);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oDead) <= 10)
    {   SetLocalInt(oDead, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oDead);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oDead) <= 10)
    {   SetLocalInt(oDead, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oDead);
    }

}

void main()
{
object oPC = GetPCSpeaker();
object theWaypoint = GetWaypointByTag("secondchance");
location rivendelia = GetLocation(theWaypoint);
AssignCommand(oPC, JumpToLocation(rivendelia));
// ApplyPenalty(oPC);
}
