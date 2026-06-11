// Show disenchant slot 6 when the target item has more than 6 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 6;
}
