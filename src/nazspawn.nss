#include "NW_I0_GENERIC"

void main()
{
    effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    effect eViz = EffectVisualEffect(VFX_DUR_AURA_ODD);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eViz, OBJECT_SELF);
}
