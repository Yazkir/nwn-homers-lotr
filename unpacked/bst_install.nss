// bst_install — install the bestiary kill-tracking wrappers on a creature.
//
// Run as OBJECT_SELF = the creature, once per creature. Stores the creature's
// original OnDamaged / OnDeath handlers and redirects both to the bestiary
// trackers (bst_ondamage / bst_ondeath), which record the kill/contributors and
// then chain the stored originals so normal behaviour (loot, alignment, respawn)
// is preserved.
//
// Installed from the common OnSpawn chokepoints (nw_c2_default9, leash_spawn)
// and, as a safety net, from leash_to_area (area OnEnter). The bst_hooked guard
// makes it idempotent no matter how many of those fire.

const int BST_EVENT_ON_DAMAGED = 5004;   // EVENT_SCRIPT_CREATURE_ON_DAMAGED
const int BST_EVENT_ON_DEATH   = 5010;   // EVENT_SCRIPT_CREATURE_ON_DEATH

void main()
{
    object oCre = OBJECT_SELF;

    if (GetObjectType(oCre) != OBJECT_TYPE_CREATURE) return;
    if (GetIsPC(oCre) || GetIsDM(oCre)) return;
    if (GetLocalInt(oCre, "bst_hooked")) return;
    SetLocalInt(oCre, "bst_hooked", 1);

    string sDmg   = GetEventScript(oCre, BST_EVENT_ON_DAMAGED);
    string sDeath = GetEventScript(oCre, BST_EVENT_ON_DEATH);

    // Don't wrap ourselves (defensive: should never happen with the guard above).
    if (sDmg   != "bst_ondamage") SetLocalString(oCre, "bst_orig_dmg",   sDmg);
    if (sDeath != "bst_ondeath")  SetLocalString(oCre, "bst_orig_death", sDeath);

    SetEventScript(oCre, BST_EVENT_ON_DAMAGED, "bst_ondamage");
    SetEventScript(oCre, BST_EVENT_ON_DEATH,   "bst_ondeath");
}
