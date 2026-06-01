// merit_can_aff_3 — Conditional: show Reward 3 only when player can afford 20 merit.
#include "merit_db"
int StartingConditional()
{
    return Merit_Available(GetPCPublicCDKey(GetPCSpeaker())) >= 20;
}
