// Show disenchant slot 2 when the target item has more than 2 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 2;
}
