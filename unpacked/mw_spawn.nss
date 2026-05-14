// mw_spawn.nss
// Spawns Meaningwave NPCs at their designated waypoints.
// Called from onmoduleload.nss on module start.
// To place an NPC: put a waypoint using blueprint mw_spawn in the area,
// set its Tag to the value in the table below, then repack.
//
// Tag              -> Creature resref    -> Area
// MW_SPAWN_PETERSON   mw_peterson_w       Rivendell Upper Halls (rivendellupperha)
// MW_SPAWN_CAMPBELL   mw_campbell_w       Balin's Tomb (balinstomb)
// MW_SPAWN_JUNG       mw_jung_w           Esgaroth Crypts (cryptsofthelosts)
// MW_SPAWN_AURELIUS   mw_aurelius_w       Gwathdor: Throne of the Lord (gwaththrone)
// MW_SPAWN_AKIRA      mw_akira            The Hall of Legends (hallofleg)
// MW_SPAWN_JOCKO      mw_jocko_w          Helm's Deep (helmsdeep001)
// MW_SPAWN_MCKENNA    mw_mckenna_w        Northern Forests of Ithilien (northernforestso)
// MW_SPAWN_WATTS      mw_watts_w          Old Forest (oldforest001)

void SpawnAtWaypoint(string sWPTag, string sResRef)
{
    object oWP = GetWaypointByTag(sWPTag);
    if (oWP == OBJECT_INVALID)
    {
        WriteTimestampedLogEntry("mw_spawn: waypoint not found: " + sWPTag + " (creature " + sResRef + " not spawned)");
        return;
    }
    if (GetObjectByTag(sResRef) != OBJECT_INVALID) return;
    // GetLocation includes the waypoint's facing, so the creature spawns oriented correctly
    CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oWP));
}

void main()
{
    SpawnAtWaypoint("MW_SPAWN_PETERSON", "mw_peterson_w");
    SpawnAtWaypoint("MW_SPAWN_CAMPBELL", "mw_campbell_w");
    SpawnAtWaypoint("MW_SPAWN_JUNG",     "mw_jung_w");
    SpawnAtWaypoint("MW_SPAWN_AURELIUS", "mw_aurelius_w");
    SpawnAtWaypoint("MW_SPAWN_AKIRA",    "mw_akira");
    SpawnAtWaypoint("MW_SPAWN_JOCKO",    "mw_jocko_w");
    SpawnAtWaypoint("MW_SPAWN_MCKENNA",  "mw_mckenna_w");
    SpawnAtWaypoint("MW_SPAWN_WATTS",    "mw_watts_w");
}
