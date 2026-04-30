// End of Combat Round. Done when an action can be preformed
// (3 seconds if hasted, else about every 6 seconds).
#include "j_inc_generic_ai"
void main()
{
    DebugActionSpeak("[Combat Round Default Call]");
    DetermineCombatRound();
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}
