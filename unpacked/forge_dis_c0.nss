// Show disenchant slot 0 when the target item has more than 0 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 0;
}
