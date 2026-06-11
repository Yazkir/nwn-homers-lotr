// Show disenchant slot 1 when the target item has more than 1 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 1;
}
