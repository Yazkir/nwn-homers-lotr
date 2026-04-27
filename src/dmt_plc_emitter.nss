//::///////////////////////////////////////////////
//:: Placeable Emitter Script
//:: voc_plc_emitter.nss
//:: Copyright (c) 2003 James Robinson
//:://////////////////////////////////////////////
/*
    This script creates visual effects both locally
    and projected into the immediate vicnity of the
    placeable. The placeables are designed for
    on-the-fly special effects for DM's who like
    their quests to have a Hollywood feel.
*/
//:://////////////////////////////////////////////
//:: Created By: James Robinson
//:: Created On: June, 2003
//:://////////////////////////////////////////////



// MAIN
// Determines which effects to use, and how to project them
////////////////////////////////////////////////
// No other variables.
////////////////////////////////////////////////
void main()
{
    // Declarations
    string sTag         = GetTag(OBJECT_SELF);
    int iDoRandom       = FALSE;
    effect eEffect;

    // Check if any players or DM's are in the area
    int iN;
    int iGotValidPC     = FALSE;
    object oPlayer      = GetFirstPC();

    while(GetIsObjectValid(oPlayer) && !iGotValidPC){
        object oArea        = GetArea(oPlayer);

        if (oArea == GetArea(OBJECT_SELF)){
            iGotValidPC = TRUE;
        }

        oPlayer             = GetNextPC();
    }


    // Decrement the counter and delete after 3 minutes of inactivity
    int iCounter        = GetLocalInt(OBJECT_SELF, "liCounter") - 1;
    SetLocalInt(OBJECT_SELF, "liCounter", iCounter);
    if (iCounter == -1){ iCounter == 30; }

    // To save memory only player visuals if a PC or DM is present.
    if (iGotValidPC){
        SetLocalInt(OBJECT_SELF, "liCounter", 30);

        // Projected Special FX
        if (sTag == "emit_pro_swirly"){ eEffect     = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION); iDoRandom = TRUE;}
        if (sTag == "emit_pro_flamejet"){ eEffect   = EffectVisualEffect(VFX_IMP_FLAME_M); iDoRandom = TRUE;}
        if (sTag == "emit_pro_lbolt"){ eEffect      = EffectVisualEffect(VFX_IMP_LIGHTNING_M); iDoRandom = TRUE;}
        if (sTag == "emit_pro_ghost"){ eEffect      = EffectVisualEffect(VFX_IMP_DEATH); iDoRandom = TRUE;}

        // Static Special FX
        if (sTag == "emit_stc_bbeam"){ eEffect      = EffectVisualEffect(VFX_IMP_HEALING_X);}
        if (sTag == "emit_stc_rbeam"){ eEffect      = EffectVisualEffect(VFX_IMP_HARM);}
        if (sTag == "emit_stc_redmist"){ eEffect    = EffectAreaOfEffect(AOE_PER_FOGKILL, "****", "****", "****");}
        if (sTag == "emit_stc_vortex"){ eEffect     = EffectVisualEffect(VFX_FNF_IMPLOSION); DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_IMPLOSION), OBJECT_SELF, 6.0));}   // HACK: forces a second casting after 3 seconds to maintain vortex
        if (sTag == "emit_stc_gas"){ eEffect        = EffectAreaOfEffect(AOE_PER_FOGGHOUL, "****", "****", "****");}

        // If it's a projection, create a vector
        if (iDoRandom == TRUE){
            vector vThis        = GetPosition(OBJECT_SELF);
            vector vOffset;
                vOffset.x       = IntToFloat(Random(32) - 16);
                vOffset.y       = IntToFloat(Random(32) - 16);
            location lEmitted   = Location(GetArea(OBJECT_SELF), vOffset + vThis, 0.0);

            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, lEmitted, 6.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLUR), OBJECT_SELF, 6.0);
        }

        // If it ain't a projection it must be static
        if (iDoRandom == FALSE){
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, GetLocation(OBJECT_SELF), 6.0);
        }
    }

    // Nobody has visited this area for 3 minutes, the emitter will self destruct to save more memory
    if (iCounter == 0){
        DestroyObject(OBJECT_SELF);
    }
}
