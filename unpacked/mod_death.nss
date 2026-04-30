 //::///////////////////////////////////////////////
//:: This script based on:
//:: Death Script
//:: NW_O0_DEATH.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:: Created By: Brent Knowles
//:: Created On: November 6, 2001
//:://////////////////////////////////////////////
void Raise(object oPlayer)
{
        effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);

        effect eBad = GetFirstEffect(oPlayer);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPlayer);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPlayer)), oPlayer);

        //Search for negative effects
        while(GetIsEffectValid(eBad))
        {
            if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
                {
                    //Remove effect if it is negative.
                    RemoveEffect(oPlayer, eBad);
                }
            eBad = GetNextEffect(oPlayer);
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oPlayer, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPlayer);
}
void main()
{
    object oPC = GetLastPlayerDied() ;
    // * make friendly to Each of the 3 common factions
    AssignCommand(oPC, ClearAllActions()) ;
        if (GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oPC) <= 10)
    {   SetLocalInt(oPC, "NW_G_Playerhasbeenbad", 10) ; // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oPC) ;
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oPC) <= 10)
    {   SetLocalInt(oPC, "NW_G_Playerhasbeenbad", 10) ; // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oPC) ;
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oPC) <= 10)
    {   SetLocalInt(oPC, "NW_G_Playerhasbeenbad", 10) ; // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oPC) ;
    }
    // * get up to four random equipped items and put them on a "corpse"


    {


    {



           {

           }
    }
    }


        DelayCommand(2.5, PopUpGUIPanel(oPC,GUI_PANEL_PLAYER_DEATH));


}
