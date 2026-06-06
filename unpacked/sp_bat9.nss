// sp_bat9  --  OnSpawn wrapper: record spawn home, then run stock nw_c2_bat9.
//
// nw_c2_bat9 is a base-game script (no source here) that doesn't store a
// "spawn" location. This wrapper records the home first, then runs the
// unchanged stock bat behavior. See leash_to_area.nss / leash_spawn.nss.

void main()
{
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));
    ExecuteScript("nw_c2_bat9", OBJECT_SELF);
}
