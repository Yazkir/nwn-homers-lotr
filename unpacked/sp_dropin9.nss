// sp_dropin9  --  OnSpawn wrapper: record spawn home, then run stock nw_c2_dropin9.
//
// nw_c2_dropin9 is a base-game script (no source in this module) that doesn't
// store a "spawn" location, so creatures using it couldn't be leashed. This
// wrapper records the home first, then runs the unchanged stock behavior.
// See leash_to_area.nss / leash_spawn.nss.

void main()
{
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));
    ExecuteScript("nw_c2_dropin9", OBJECT_SELF);
}
