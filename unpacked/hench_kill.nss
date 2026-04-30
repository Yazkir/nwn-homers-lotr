//henchman leaves PC.

#include "nw_i0_henchman"

void main()
{
SetFormerMaster(GetPCSpeaker(), OBJECT_SELF);
RemoveHenchman(GetPCSpeaker());
ClearAllActions();
DeleteLocalInt(GetPCSpeaker(), "hench");
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisappear(),OBJECT_SELF);

}
