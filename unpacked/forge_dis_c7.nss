// Show disenchant slot 7 when the target item has more than 7 properties.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_DIS_COUNT") > 7;
}
