// On Rested -Working-
// This will play the sitting animation for 6 seconds, just something for resting.
// Also, walks waypoints (as resting would stop this) :-) and signals event (if so be)
// Feel free to edit.
#include "j_inc_spawnin"
void main()
{
    ClearAllActions();
    ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 6.0);
    DelayCommand(6.0, WalkWayPoints());
    if(GetSpawnInCondition(NW_FLAG_RESTED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1009));
    }
}
