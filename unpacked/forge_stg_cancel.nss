// Abandon the disenchant plan: nothing was mutated, so the item is left whole
// and exactly as legal as it was before. Just clear the staging plan.
void main()
{
    DeleteLocalInt(GetPCSpeaker(), "FORGE_STG_MASK");
}
