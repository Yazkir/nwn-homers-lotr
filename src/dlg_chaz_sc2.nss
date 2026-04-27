//::///////////////////////////////////////////////
//:: FileName dlg_chaz_sc2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/8/2006 4:35:46 AM
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on the player's level
    // And if they have enough money
    if(GetHitDice(GetPCSpeaker()) < 5 | GetGold(GetPCSpeaker()) < 50000) return TRUE;

    return FALSE;
}
