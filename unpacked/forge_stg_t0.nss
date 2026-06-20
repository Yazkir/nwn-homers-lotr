// Toggle plan bit 0 (strike/keep the 0th permanent property). The menu
// re-shows via the D1 entry (forge_stg_anvil), which re-primes the cues.
void main()
{
    object oPC = GetPCSpeaker();
    SetLocalInt(oPC, "FORGE_STG_MASK",
        GetLocalInt(oPC, "FORGE_STG_MASK") ^ (1 << 0));
}
