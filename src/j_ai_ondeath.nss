// OnDeath
// Speeded up no end, when compiling, with seperate Include.
// I have witnessed no errors, so -Working-
// Cleans up all un-droppable items, all ints and all local things when destroyed.
#include "j_inc_ondeath"

void main()
{
    int iDeathEffect = GetLocalInt(OBJECT_SELF, "AI_DEATH_VISUAL_EFFECT");
    if(iDeathEffect > 0)
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iDeathEffect), GetLocation(OBJECT_SELF));
    }
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(GetLevelByClass(CLASS_TYPE_COMMONER) > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        object oKiller = GetLastKiller();
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }
    // Always shout when we are attacked, if not fighting.
    SpeakString("I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
    // Speaks the set death speak.
    string sDeathString = GetLocalString(OBJECT_SELF, "AI_TALK_ON_DEATH");
    if(sDeathString != "")
        SpeakString(sDeathString);

    // Sets that we should die. Used in the check.
    SetLocalInt(OBJECT_SELF, "IS_DEAD", TRUE);
    // We will actually dissapear after 30.0 seconds if not raised.
    int iTime = GetLocalInt(OBJECT_SELF, "AI_CORPSE_DESTROY_TIME");
    if(iTime > 0)
    {   DelayCommand(IntToFloat(iTime), DeathCheck());   }
    else
    {   DelayCommand(30.0, DeathCheck()); iTime = 30;    }
    object oKiller = GetLastKiller();
//    SpeakString("[AI] " + GetName(OBJECT_SELF) + " [Area] " + GetName(GetArea(OBJECT_SELF)) + " [Debug] Dead. Checking corpse status in " + IntToString(iTime) + " [Killer] " + GetName(oKiller), TALKVOLUME_SILENT_TALK);
//    WriteTimestampedLogEntry("[AI] " + GetName(OBJECT_SELF) + " [Area] " + GetName(GetArea(OBJECT_SELF)) + " [Debug] Dead. Checking corpse status in " + IntToString(iTime) + " [Killer] " + GetName(oKiller));
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
}
