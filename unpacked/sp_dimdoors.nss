// sp_dimdoors  --  OnSpawn wrapper: record spawn home, then run stock nw_c2_dimdoors.
//
// nw_c2_dimdoors is a base-game script (no source here) that gives the creature
// Dimension Door AI but doesn't store a "spawn" location. This wrapper records
// the home first, then runs the unchanged stock behavior. Dimension Door is a
// within-area teleport, so it never crosses an area boundary and never trips the
// leash; only being led through an area transition does. See leash_to_area.nss.

void main()
{
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));
    ExecuteScript("nw_c2_dimdoors", OBJECT_SELF);
    // Bestiary kill-tracking: install the OnDamaged/OnDeath wrappers (idempotent).
    ExecuteScript("bst_install", OBJECT_SELF);
}
