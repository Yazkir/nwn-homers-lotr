// merit_can_aff_4 — Conditional: show Reward 4 only when player can afford 35 merit.
#include "merit_db"
int StartingConditional()
{
    return Merit_Available(GetPCPublicCDKey(GetPCSpeaker())) >= 35;
}
