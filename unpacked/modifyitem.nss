#include "itemprocs"

void main()
{
    object oPC = GetPCSpeaker();

    //Transfer gold
    int iValue = GetLocalInt(oPC, "MODIFY_VALUE");
    int iDiff = GetLocalInt(oPC, "MODIFY_DIFF");
    object oItem = GetLocalObject(oPC, "MODIFY_ITEM");

    //Per-forge value ceiling: refuse enchants that would raise the item's
    //assessed value past this forge's cap (0 = uncapped). Only value-increasing
    //enchants (iDiff == 1) can breach it; refunds/no-change pass through.
    //Prospective new value = current value + quoted cost (MODIFY_VALUE).
    int iMax = GetLocalInt(oPC, "MODIFY_MAX");
    if (iMax > 0 && iDiff == 1 && GetGoldPieceValue(oItem) + iValue > iMax)
        {
        SpeakString("I'm sorry — my forge cannot work this piece any further. I "
            + "dare not raise its worth past " + IntToString(iMax) + " gold. Take "
            + "it to a greater forge if you would push it beyond that.");
        return;
        }

    //No refunds: refuse any change that would lower the item's assessed value.
    //The forges only enchant an item upward — never pay out for a downgrade.
    if (iDiff == -1)
        {
        SpeakString("I shape metal forward, not back — I'll not unmake the work "
            + "already in this piece for a handful of coin. Choose an enchantment "
            + "that betters it, or take it as it is.");
        return;
        }

    if (iDiff == 1 && GetGold(oPC) < iValue)
        {
        SpeakString("Oops.. looks like you don't have the gold for this.");
        return;
        }

    if (iDiff == 1)
        {
        TakeGoldFromCreature(iValue, oPC, TRUE);
        SetLocalInt(oItem, "FORGE_GP_INVESTED",
            GetLocalInt(oItem, "FORGE_GP_INVESTED") + (iValue * 80 / 100));
        }

    //Modify item
    itemproperty ip = GetNewProperty(oItem);

    if ( GetIsItemPropertyValid(ip))
        CustomAddProperty(oItem, ip);
}
