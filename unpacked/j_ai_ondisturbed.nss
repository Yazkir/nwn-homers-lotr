// On Disturbed
// This will attack pickpockets, and inventory disturbers.
#include "j_inc_generic_ai"

void main()
{
    // We will set weapons if it is a weapon.
    int nBase = GetBaseItemType(GetInventoryDisturbItem());
    if(nBase <= 14 || nBase == 18 || nBase == 20 || nBase == 22 || nBase == 25 ||
       nBase == 27 || nBase == 28 || (nBase >= 31 && nBase <= 33) || nBase == 35 ||
       nBase == 37 || nBase == 38 || (nBase >= 40 && nBase <= 42) || nBase == 47 ||
       nBase == 50 || nBase == 51 || nBase == 53 || (nBase >= 55 && nBase <= 61) ||
       nBase == 63 /*Added spell items*/ || nBase == 19 || nBase == 24 || nBase == 29 ||
       nBase == 34 || nBase == 39 || nBase == 43 || nBase == 44 || nBase == 46 || nBase == 49 ||
       nBase == 52 || nBase == 54 || nBase == 68 || nBase == 75 || nBase == 75 || nBase == 79)
    {
        // I can't seem to get the include to compile properly. Go figure...
        ExecuteScript("j_ai_setweapons", OBJECT_SELF);
    }
    object oTarget = GetLastDisturbed();
    if(GetIsObjectValid(oTarget) && GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_STOLEN)
    {
        if(!GetIsFighting(FALSE) && !GetFactionEqual(oTarget) && !GetIsDM(oTarget))
        {
            SpeakString("NW_CALL_TO_ARMS", TALKVOLUME_SILENT_TALK);
            DebugActionSpeak("Disturbed (Normally pickpocket) [Disturber] " + GetName(oTarget));
            DetermineCombatRound(oTarget);
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DISTURBED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1008));
    }
}
