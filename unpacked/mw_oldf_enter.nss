#include "mw_spawn_inc"

void main()
{
    // Keep creatures in their spawn area (anti-kiting); see leash_to_area.nss.
    ExecuteScript("leash_to_area", OBJECT_SELF);

    ExecuteScript("d_cleartrash", OBJECT_SELF);
    MWSpawnAtWaypoint("MW_SPAWN_WATTS", "mw_watts_w");
}
