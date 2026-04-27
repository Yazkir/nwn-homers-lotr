//has NPC sit on things tagged 'ThroneDeath'

#include "NW_I0_GENERIC"
void main()
{
ActionSit (GetNearestObjectByTag ("ThroneDeath", OBJECT_SELF));
SetBaseAttackBonus(5,OBJECT_SELF);

}

