// Show disenchant slot 4 when the target item has more than 4 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 4;
}
