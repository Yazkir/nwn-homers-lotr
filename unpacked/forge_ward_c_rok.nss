// Forge Warden gate: TRUE when the last blueprint revert succeeded.
int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "FORGE_RVT_OK");
}
