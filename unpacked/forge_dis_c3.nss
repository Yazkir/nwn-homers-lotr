// Show disenchant slot 3 when the target item has more than 3 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 3;
}
