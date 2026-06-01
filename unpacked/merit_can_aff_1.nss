// merit_can_aff_1 — Conditional: show Reward 1 only when player can afford 5 merit.
#include "merit_db"
int StartingConditional()
{
    return Merit_Available(GetPCPublicCDKey(GetPCSpeaker())) >= 5;
}
