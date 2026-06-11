// Forge Warden release gate: TRUE when no illegal gear remains on the PC.
#include "forge_inc"

int StartingConditional()
{
    return !GetIsObjectValid(ForgeFindIllegalItem(GetPCSpeaker()));
}
