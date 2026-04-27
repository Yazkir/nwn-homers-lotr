// On Spell Cast At
// -Working-
#include "j_inc_generic_ai"

void main()
{
    object oCaster = GetLastSpellCaster();
    object oEnemy = GetLastHostileActor(oCaster);
    if(GetIsObjectValid(oCaster) && !GetIsDM(oCaster))
    {
        if(GetLastSpellHarmful())
        {
            // If we are not fighting, and the caster is in the area, determine it on them,
            // else it is probably an AOE spell, or they have run (EG delayed fireball blast)
            // so just determine it (to heal, attack another or anything of the sort)
            if(!GetFactionEqual(oCaster))
            {
                // Hostile spell speaksting, if set.
                string sSpell = GetLocalString(OBJECT_SELF, "AI_TALK_ON_HOSTILE_SPELL_CAST_AT");
                if(sSpell != "")
                {
                    if(d100() <= GetLocalInt(OBJECT_SELF, "AI_PERCENT_TO_SHOUT_ON_HOSTILE_SPELL_CAST_AT"))
                        SpeakString(sSpell);
                }
                if(!GetIsFighting(FALSE))
                {
                    if(GetArea(oCaster) == GetArea(OBJECT_SELF))
                    {
                        DebugActionSpeak("Hostile Spell (Not in combat). [Caster] " + GetName(oCaster));
                        DetermineCombatRound(oCaster);// They are in this area! Attack!
                    }
                    else
                    {
                        DebugActionSpeak("Hostile Spell (Not in combat, nor same area). [Caster] " + GetName(oCaster));
                        DetermineCombatRound();// May find another hostile to attack...
                    }
                }
            }
            else // else a friend - maybe we just are round the cornor, but are hit by an AOE spell
            {
                if(!GetIsObjectValid(GetAttackTarget()) && !GetIsFighting())
                {
                    if(GetIsObjectValid(oEnemy))
                    {
                        SpeakString("CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
                        DebugActionSpeak("Hostile Spell (Not in combat, nor same area). Ally caster though. Attacking Hostile Actor [Caster] " + GetName(oCaster) + " [Actor] " + GetName(oEnemy));
                        DetermineCombatRound(oEnemy);
                    }
                    else
                    {
                        SpeakString("CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
                        DebugActionSpeak("Hostile Spell (Not in combat, nor same area). Ally caster though. No actor [Caster] " + GetName(oCaster));
                        DetermineCombatRound();
                    }
                }
            }
        }
        else // Else is friendly - may be that we cannot see combat or something...
        {
            if(!GetIsObjectValid(GetAttackTarget()) && !GetIsFighting())
            {
                if(GetIsFriend(oCaster))
                {
                    if(GetIsObjectValid(oEnemy))
                    {
                        SpeakString("CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
                        DebugActionSpeak("Friendly Spell (Not in combat). Attacking Hostile Enemy of caster [Caster] " + GetName(oCaster) + " [Actor] " + GetName(oEnemy));
                        DetermineCombatRound(oEnemy);
                    }
                    else
                    {
                        SpeakString("CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
                        DebugActionSpeak("Friendly Spell (Not in combat). ANo hostile enemy of them though. [Caster] " + GetName(oCaster));
                        DetermineCombatRound();
                    }
                }
                else if(GetIsEnemy(oCaster) && !GetFactionEqual(oCaster))
                {
                    SpeakString("CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
                    DebugActionSpeak("Friendly Spell (Not in combat). Hostile caster. [Caster] " + GetName(oCaster));
                    DetermineCombatRound(oCaster);
                }
                else
                {
                    SpeakString("CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
                    DebugActionSpeak("Friendly Spell (Not in combat). Equal faction, but enemy caster (?!) [Caster] " + GetName(oCaster));
                    DetermineCombatRound();
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1011));
    }
}
