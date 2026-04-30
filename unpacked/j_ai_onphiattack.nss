// On Attacked -Working-
// No checking for fleeing or warnings.
// Very boring really!
#include "j_inc_generic_ai"

void main()
{
    object oAttacker = GetLastAttacker();
    if(GetIsObjectValid(oAttacker) && !GetFactionEqual(oAttacker) && !GetIsDM(oAttacker))
    {
        // Speak the phisically attacked string, if applicable.
        string sSpell = GetLocalString(OBJECT_SELF, "AI_TALK_ON_PHISICALLY_ATTACKED");
        if(sSpell != "")
        {
            if(d100() <= GetLocalInt(OBJECT_SELF, "AI_PERCENT_TO_SHOUT_ON_PHISICALLY_ATTACKED"))
                SpeakString(sSpell);
        }
        // If we are not fighting, and they are in the area, attack. Else, determine anyway.
        if(!GetIsFighting(FALSE))
        {
            if(GetArea(oAttacker) == GetArea(OBJECT_SELF))
            {
                DebugActionSpeak("Phisically Attacked. Attacking back. [Attacker(enemy)] " + GetName(oAttacker));
                DetermineCombatRound(oAttacker);
            }
            else
            {
                DebugActionSpeak("Phisically Attacked. Not same area. [Attacker(enemy)] " + GetName(oAttacker));
                DetermineCombatRound();// May find another hostile to attack...
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1005));
    }
}
