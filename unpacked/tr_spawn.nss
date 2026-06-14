//::///////////////////////////////////////////////
//:: Name: tr_spawn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This goes in the onspawn node for a creature.
     make sure the tr_conv script is in the
     onconversation node for the creature and that
     all other scripts are removed to prevent this
     trainer from attacking anything by mistake.
*/
//:://////////////////////////////////////////////
//:: Created By: Cylvia
//:: Created On: 1-2-2004
//:://////////////////////////////////////////////
void main ()
{
    // Record spawn area so the creature can be leashed to it (see leash_to_area.nss).
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));

    // Bestiary kill-tracking: install the OnDamaged/OnDeath wrappers (idempotent).
    ExecuteScript("bst_install", OBJECT_SELF);

SetPlotFlag(OBJECT_SELF,TRUE);
SetListenPattern(OBJECT_SELF,"*n",1111);
}
