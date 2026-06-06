#include "NW_I0_GENERIC"

void main()
{
    // Record spawn area so the creature can be leashed to it (see leash_to_area.nss).
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));

    effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    effect eViz = EffectVisualEffect(VFX_DUR_AURA_ODD);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eViz, OBJECT_SELF);
}
