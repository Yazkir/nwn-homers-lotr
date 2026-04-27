// On Blocked -Working-
// Added in user defined constant - won't open any doors.
// 0 = Default (even if not set) opens as appropriate
// 1 = Always bashes the door.
// 2 = Never open any doors
// 3 = Never opens plot doors
#include "j_inc_equipweapo"
// On Blocked - By a door
/* They will: (int is intellgience needed)
    1. Open if not trapped (7 int)
    2. Unlock if possible, and rank is high enough, and it needs no key and is not trapped (7 int)
    3. Untrap the door, if possible, if trapped (7 int)
    4. Else, if has high enough stats, try Knock. (10 int)
    6. Else Equip appropriate weapons and bash (5 int)
*/
void main()
{
    object oDoor = GetBlockingDoor();
    int iDoorIntelligence = GetLocalInt(OBJECT_SELF, "AI_DOOR_INTELLIGENCE");
    if(iDoorIntelligence == 1)// 1 = Always bashes the doors, plot, locked or anything.
    {
        ClearAllActions();
        EquipAppropriateWeapons(oDoor);
        ActionAttack(oDoor);
        return;
    }
    else if(iDoorIntelligence == 2)// 2 = Never open anything, bashing or not.
    {
        return;
    }
    else if(iDoorIntelligence == 3)// 3 = Never tries anything against plot doors.
    {
        if(GetPlotFlag(oDoor)) return;
    }
    int iInt = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE);
    if(iInt >= 5)
    {
        if(iInt >= 7)
        {
            if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) && !GetLocked(oDoor) && !GetIsTrapped(oDoor) &&
                (!GetLockKeyRequired(oDoor) || (GetLockKeyRequired(oDoor) && GetItemPossessor(GetObjectByTag(GetLockKeyTag(oDoor))) == OBJECT_SELF)))
            {
                DoDoorAction(oDoor, DOOR_ACTION_OPEN);
                return;
            }
            if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_UNLOCK) && !GetIsTrapped(oDoor) && GetLocked(oDoor) && !GetLockKeyRequired(oDoor) && (GetSkillRank(SKILL_OPEN_LOCK) >= (GetLockLockDC(oDoor)-20)))
            {
                DoDoorAction(oDoor, DOOR_ACTION_UNLOCK);
                return;
            }
            if(iInt >= 10)
            {
                if((GetIsDoorActionPossible(oDoor, DOOR_ACTION_KNOCK)) && GetLockUnlockDC(oDoor) <= 25 &&
                     !GetLockKeyRequired(oDoor) && GetHasSpell(SPELL_KNOCK))
                {
                    DoDoorAction(oDoor, DOOR_ACTION_KNOCK);
                    return;
                }
            }
            // If Our Int is over 5, we will bash after everything else.
            if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && !GetPlotFlag(oDoor))
            {
                ClearAllActions();
                EquipAppropriateWeapons(oDoor);
                ActionAttack(oDoor);
                return;
            }
        }
    }
}
