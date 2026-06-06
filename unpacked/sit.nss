//has NPC sit on things tagged 'ThroneDeath'

#include "NW_I0_GENERIC"
void main()
{
    // Record spawn area so the creature can be leashed to it (see leash_to_area.nss).
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));

ActionSit (GetNearestObjectByTag ("ThroneDeath", OBJECT_SELF));
SetBaseAttackBonus(5,OBJECT_SELF);

}

