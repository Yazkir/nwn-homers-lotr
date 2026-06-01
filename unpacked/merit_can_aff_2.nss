// merit_can_aff_2 — Conditional: show Reward 2 only when player can afford 10 merit.
#include "merit_db"
int StartingConditional()
{
    return Merit_Available(GetPCPublicCDKey(GetPCSpeaker())) >= 10;
}
