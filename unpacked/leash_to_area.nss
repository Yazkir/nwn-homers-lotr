// leash_to_area  --  Area OnEnter: keep creatures in their spawn area.
//
// Anti-kiting rule: players must not be able to lead a creature (especially a
// boss) out of its home area and across the module to fight other bosses. This
// fires whenever any object enters the area (no heartbeat needed). If the
// entering creature is in an area other than the one it spawned in, it is sent
// straight back to its spawn point.
//
// Wired as the OnEnter event on every area. The creature's home is the "spawn"
// LocalLocation, recorded by leash_init (at module load) or by the creature's
// own OnSpawn (nw_c2_default9 / x2_def_spawn).
//
// To exempt a creature that is MEANT to travel between areas (escorts, ambient
// wanderers, scripted plot movers), set local int "NO_LEASH" = 1 on its
// blueprint or instance.

void main()
{
    object oCre = GetEnteringObject();

    if (GetObjectType(oCre) != OBJECT_TYPE_CREATURE) return;
    if (GetIsPC(oCre) || GetIsDM(oCre) || GetIsDMPossessed(oCre)) return;

    // Never leash anything that follows a player: henchmen, summons,
    // familiars, animal companions, dominated creatures all have a master.
    if (GetIsObjectValid(GetMaster(oCre))) return;

    // Per-creature opt-out for intended cross-area travelers.
    if (GetLocalInt(oCre, "NO_LEASH")) return;

    location lHome   = GetLocalLocation(oCre, "spawn");
    object   oHome   = GetAreaFromLocation(lHome);
    if (!GetIsObjectValid(oHome)) return;       // no home recorded -> leave alone
    if (GetArea(oCre) == oHome) return;         // already in its home area

    // Led (or wandered) out of its spawn area -> send it home.
    AssignCommand(oCre, ClearAllActions());
    AssignCommand(oCre, JumpToLocation(lHome));
}
