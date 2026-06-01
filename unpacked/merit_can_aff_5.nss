// merit_can_aff_5 — Conditional: show Reward 5 only when player can afford 50 merit.
#include "merit_db"
int StartingConditional()
{
    return Merit_Available(GetPCPublicCDKey(GetPCSpeaker())) >= 50;
}
