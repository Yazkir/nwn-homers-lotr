void main()
{
    object oPC = GetPCSpeaker();
    if (GetGold(oPC) < 10000)
    {
        ActionSpeakString("Oops, you must have dropped your gold..", TALKVOLUME_TALK);
        return;
    }

    TakeGoldFromCreature(10000, oPC, TRUE);

    int slot;
    for (slot = 0; slot < NUM_INVENTORY_SLOTS; slot++)
    {
        object oEquip = GetItemInSlot(slot, oPC);
        if (oEquip != OBJECT_INVALID)
            SetIdentified(oEquip, TRUE);
    }

    object oItem = GetFirstItemInInventory(oPC);
    while (oItem != OBJECT_INVALID)
    {
        SetIdentified(oItem, TRUE);
        oItem = GetNextItemInInventory(oPC);
    }
}
