// Show disenchant slot 5 when the target item has more than 5 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 5;
}
