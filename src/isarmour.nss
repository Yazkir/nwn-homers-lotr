int StartingConditional()
{
   object oItem = GetLocalObject(GetPCSpeaker(), "MODIFY_ITEM");
    int iTyp = GetBaseItemType(oItem);
    return (
        (iTyp == BASE_ITEM_ARMOR ) ||
        (iTyp == BASE_ITEM_LARGESHIELD ) ||
        (iTyp == BASE_ITEM_SMALLSHIELD ) ||
        (iTyp == BASE_ITEM_TOWERSHIELD )
        );
}
