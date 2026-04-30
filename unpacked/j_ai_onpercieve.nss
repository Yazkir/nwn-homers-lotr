// On Percieve    -Working-
// If the target is an enemy, attack
// Will determine combat round on that person, is an enemy, basically.
// Includes shouting for a big radius - if the spawn in condition is set to this.
#include "j_inc_generic_ai"

void main()
{
    object oPerceived = GetLastPerceived();
    // This is the equivalent of a force conversation bubble, should only be used if you want an NPC
    // to say something while he is already engaged in combat.
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION))
        if(GetIsPC(oPerceived) && GetLastPerceptionSeen())
            SpeakOneLinerConversation();
    if(GetIsEnemy(oPerceived) && !GetFactionEqual(oPerceived) && !GetIsDM(oPerceived))
    {
        SpeakString("I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        if(GetLastPerceptionVanished())
        {
        //  If the percieved were an enemy, follow if they went.
             if((GetAttemptedAttackTarget() == oPerceived ||
                 GetAttemptedSpellTarget() == oPerceived ||
                 GetAttackTarget() == oPerceived) && GetArea(oPerceived) != GetArea(OBJECT_SELF))
            {
                SpeakString("AI, Dissapeared target, Attacking " + GetName(oPerceived), TALKVOLUME_SILENT_TALK);
                DetermineCombatRound(oPerceived);
            }
        }
        //Do not bother checking the last target seen if already fighting
        else if(!GetIsFighting(FALSE))
        {
            //Check if the last percieved creature was actually seen, or heard of course.
            if((GetLastPerceptionSeen() || GetLastPerceptionHeard()) && !GetLastPerceptionInaudible())
            {
                SetFacingPoint(GetPosition(oPerceived));
                if(d100() <= GetLocalInt(OBJECT_SELF, "AI_PERCENT_TO_SHOUT_ON_PERCIEVE"))
                {
                    string sPercieve = GetLocalString(OBJECT_SELF, "AI_TALK_ON_PERCIEVE_ENEMY");
                    if(sPercieve != ""){ SpeakString(sPercieve); }
                    else{ PlayRandomAttackTaunt(); }
                }
                // Get all allies in 60M to come to thier aid. Talkvolume silent shout does not seem to work well.
                if(GetSpawnInCondition(BOSS_MONSTER_SHOUT))
                {
                    ShoutBossShout(oPerceived);
                }
                if(GetIsDead(oPerceived))
                {
                    ClearAllActions();
                    DebugActionSpeak("Dead (enemy) target seen/heard. Should Shouting & Moving to " + GetName(oPerceived));
                    ActionMoveToLocation(GetLocation(oPerceived), TRUE);
                    DelayCommand(10.0, DetermineCombatRound());
                }
                else
                {
                    DebugActionSpeak("Percieved Enemy seen/heard & Should Shout [Target] " + GetName(oPerceived));
                    DetermineCombatRound(oPerceived);
                }
            }
        }
    }
    else if(GetFactionEqual(oPerceived) && !GetIsDM(oPerceived) && GetIsDead(oPerceived))
    {
        SpeakString("I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        if(!GetIsFighting(FALSE) && (GetLastPerceptionSeen() || GetLastPerceptionHeard()) && !GetLastPerceptionInaudible())
        {
            ClearAllActions();
            DebugActionSpeak("Percieved Dead Friend, and should shout [Friend]" + GetName(oPerceived));
            ActionMoveToObject(oPerceived, TRUE);
            DelayCommand(8.0, DetermineCombatRound());
        }
    }
    //Linked up to the special conversation check to initiate a special one-off conversation
    //to get the PCs attention
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) && GetIsPC(oPerceived))
    {
        ActionStartConversation(OBJECT_SELF);
    }
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) && GetLastPerceptionSeen())
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1002));
    }
}
