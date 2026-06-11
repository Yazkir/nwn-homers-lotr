// Forge Warden greeting gate: TRUE when the PC still carries illegal gear.
#include "forge_inc"

int StartingConditional()
{
    return GetIsObjectValid(ForgeFindIllegalItem(GetPCSpeaker()));
}
