// OnConversation/ Listen to shouts.
// Documented, and checked. -Working-
// Added spawn in condition - Never clear actions when talking.
#include "j_inc_generic_ai"

void main()
{
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    // Conversation if not a shout.
    if(nMatch == -1)
    {
        if(GetCommandable() && !GetIsFighting())
        {
            // If we are set to NOT clear all actions, we won't.
            if(!GetSpawnInCondition(NO_CLEAR_ACTIONS_BEFORE_CONVERSATION))
            {
                ClearAllActions();
            }
            BeginConversation();
        }
    }
    // If it is a valid shout...and a valid shouter.
    else if(nMatch != -1 && GetIsObjectValid(oShouter) && !GetIsDM(oShouter))
    {
        if(GetIsFriend(oShouter) && nMatch != 0)
        {
            // If it is an "associate command" and not attack nearest (below) ignore.
            if(nMatch < 0 && nMatch != ASSOCIATE_COMMAND_ATTACKNEAREST)
            {
                return;
            }
            // If they are a friend, not a PC, and we are not fighting, react!
            // Will not react to any old talk though.
            if(nMatch != 0 && !GetIsPC(oShouter) && !GetIsFighting())
            {
                // We will not react to 0 shouts.
                // default intruder to invalid anyway.
                object oIntruder = OBJECT_INVALID;
                if(nMatch == ASSOCIATE_COMMAND_ATTACKNEAREST)
                {
                    if(GetSpawnInCondition(GROUP_LEADER, oShouter))
                    {
                        oIntruder = GetLocalObject(oShouter, "AI_TO_ATTACK");
                    }
                    else // If they are not a leader, we won't react any futhur.
                    {
                        return;
                    }
                }
                if(nMatch == 2)// Blocker shout.
                {
                   oIntruder = GetLocalObject(oShouter, "NW_BLOCKER_INTRUDER");
                }
                else if(nMatch == 5)// "leader flee now"
                {
                    if(GetSpawnInCondition(GROUP_LEADER, oShouter))
                    {
                        oIntruder = GetLocalObject(oShouter, "AI_TO_FLEE");
                    }
                    else // If they are not a leader, we won't react any futhur.
                    {
                        return;
                    }
                }
                if(!GetIsObjectValid(oIntruder) && nMatch != 5)
                {
                    oIntruder = GetLastHostileActor(oShouter);
                    if(!GetIsObjectValid(oIntruder))
                    {
                        oIntruder = GetAttackTarget(oShouter);
                        if(!GetIsObjectValid(oIntruder))
                        {
                            oIntruder = GetLocalObject(oShouter, "AI_TO_ATTACK");
                        }
                    }
                }
                DebugActionSpeak("Responding to shout [Ally] " + GetName(oShouter) + " [Number] " + IntToString(nMatch) + " [Intruder] " + GetName(oIntruder));
                RespondToShout(oShouter, nMatch, oIntruder);
            }
        }
        else if(GetIsEnemy(oShouter))
        {
            // If we hear anything said by an enemy, and are not fighting, attack them!
            if((GetArea(oShouter) == GetArea(OBJECT_SELF)) && !GetIsFighting())
                // the negatives are associate shouts, 1-6 are my shouts. 0 is anything
            {
                DebugActionSpeak("Responding to shout [Enemy] " + GetName(oShouter) + " Who has spoken!");
                DetermineCombatRound(oShouter);
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1004));
    }
}
