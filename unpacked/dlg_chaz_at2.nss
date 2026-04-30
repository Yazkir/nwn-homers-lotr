// Markshire Persistent Chest System (MPCS)
// Thrym of Markshire
//
// Create and Bond the Chest to the PC
// and take their 50,000 gold.  :)

void main()
{
    object oPC = GetPCSpeaker();

    string sCDKey = GetPCPublicCDKey(oPC);

    string sPCName = GetName(oPC);

    effect eBeam = EffectBeam(VFX_BEAM_SILENT_HOLY, oPC, BODY_NODE_CHEST);

    location lTarget = GetLocation(GetNearestObjectByTag("PC_SPAWN_POINT", OBJECT_SELF));

    TakeGoldFromCreature(50000, oPC);

    object oChest = CreateObject(OBJECT_TYPE_CREATURE, "persistent_chest", lTarget, FALSE);

    SetName(oChest, sPCName + "'s Chest");

    object oKey = CreateItemOnObject("ms_pc_key", oPC);

    SetName(oKey, "Key to " + sPCName + "'s Chest");

    CreateItemOnObject("ms_pc_instr", oPC);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oChest, 2.0);

    SetLocalString(oChest, "OWNER_ID", sCDKey);

    SetLocalString(oKey, "OWNER_ID", sCDKey);
}
