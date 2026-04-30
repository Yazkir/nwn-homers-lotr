int StartingConditional()
{
    object oItem = GetLocalObject(GetPCSpeaker(), "MODIFY_ITEM");
    int iTyp = GetBaseItemType(oItem);
    return (
        (iTyp == BASE_ITEM_HEAVYCROSSBOW ) ||
        (iTyp == BASE_ITEM_LIGHTCROSSBOW ) ||
        (iTyp == BASE_ITEM_LONGBOW ) ||
        (iTyp == BASE_ITEM_SHORTBOW ) ||
        (iTyp == BASE_ITEM_SLING )
        );
}


