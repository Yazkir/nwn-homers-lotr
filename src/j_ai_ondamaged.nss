// OnDamaged -Working-
#include "j_inc_generic_ai"
void main()
{
    // Check to see if we will polymorph.
    int iPolymorph = GetLocalInt(OBJECT_SELF, "AI_POLYMORPH_INTO");
    if(iPolymorph > 0)
    {
        if(!GetHasEffect(EFFECT_TYPE_POLYMORPH))// We won't polymorph if already so
        {
            iPolymorph = (iPolymorph - 1);// We remove one to get the actual value stored, because 0 is werewolf.
            effect eShape = SupernaturalEffect(EffectPolymorph(iPolymorph));
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShape, OBJECT_SELF));
            DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF)));
        }
        DeleteLocalInt(OBJECT_SELF, "AI_POLYMORPH_INTO");// Always delete the int, to perform once.
    }
    object oDamager = GetLastDamager();
    if(GetIsObjectValid(oDamager) && !GetFactionEqual(oDamager) && !GetIsDM(oDamager))
    {
        // Set the max elemental damage done, for better use of elemental protections.
        // This is set for the most damage...so it could be 1 (for a +1 fire weapon, any
        // number of hits) or over 50 (good fireball).
        int iDamageDone = GetDamageDealtByType(DAMAGE_TYPE_ACID | DAMAGE_TYPE_COLD
                | DAMAGE_TYPE_ELECTRICAL | DAMAGE_TYPE_FIRE | DAMAGE_TYPE_SONIC);
        if(iDamageDone > GetMaxDamageDone())
        {
            SetLocalInt(OBJECT_SELF, "MAX_ELEMENTAL_DAMAGE", iDamageDone);
        }
        // Speak the damaged string, if applicable.
        string sSpell = GetLocalString(OBJECT_SELF, "AI_TALK_ON_DAMAGED");
        if(sSpell != "")
        {
            if(d100() <= GetLocalInt(OBJECT_SELF, "AI_PERCENT_TO_SHOUT_ON_DAMAGED"))
                SpeakString(sSpell);
        }
        // If we are not attacking anything, and not in combat, react!
        if(!GetIsFighting())
        {
            if(GetArea(oDamager) == GetArea(OBJECT_SELF))
            {
                DebugActionSpeak("Damaged (not in combat) [Enemy] " + GetName(oDamager));
                DetermineCombatRound(oDamager);
            }
            else
            {
                DebugActionSpeak("Damaged (not in combat, and different area) [Enemy] " + GetName(oDamager));
                DetermineCombatRound();
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1006));
    }
}
