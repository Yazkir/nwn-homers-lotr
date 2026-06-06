// leash_spawn  --  Minimal OnSpawn: record the creature's spawn area, no AI.
//
// Assigned as ScriptSpawn to creatures that previously had a blank OnSpawn so
// they store a "spawn" home and can be leashed to their spawn area (see
// leash_to_area.nss). Deliberately does nothing else, preserving the "inert"
// behavior those creatures had with no spawn script.

void main()
{
    SetLocalLocation(OBJECT_SELF, "spawn", GetLocation(OBJECT_SELF));
}
