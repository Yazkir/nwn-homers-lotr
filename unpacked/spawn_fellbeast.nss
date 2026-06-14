#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"

void main()
{
    // Record spawn area so the creature can be leashed to it (see leash_to_area.nss).
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));

    // Bestiary kill-tracking: install the OnDamaged/OnDeath wrappers (idempotent).
    ExecuteScript("bst_install", OBJECT_SELF);

    effect eVis = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    effect eVis1 = EffectVisualEffect(VFX_DUR_GLOW_BROWN);


    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis1, OBJECT_SELF);


// DEFAULT GENERIC BEHAVIOR (DO NOT TOUCH) *****************************************************************************************
    SetListeningPatterns();    // Goes through and sets up which shouts the NPC will listen to.
    WalkWayPoints();           // Optional Parameter: void WalkWayPoints(int nRun = FALSE, float fPause = 1.0)
                               // 1. Looks to see if any Way Points in the module have the tag "WP_" + NPC TAG + "_0X", if so walk them
                               // 2. If the tag of the Way Point is "POST_" + NPC TAG the creature will return this way point after
                               //    combat.
    GenerateNPCTreasure();     //* Use this to create a small amount of treasure on the creature
    SetListenPattern(OBJECT_SELF, "**", 20600); //listen to all text
    SetLocalInt(OBJECT_SELF, "hls_Listening", 1); //listen to all text
    SetListening(OBJECT_SELF, TRUE);          //be sure NPC is listening
}
