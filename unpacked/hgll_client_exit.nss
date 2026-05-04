// hgll_client_exit — NWNX:EE port
//
// Originally pushed a queued Letoscript string into the NWNX2 IPC channel on
// logout to mutate the BIC file. With NWNX:EE, HGLL mutations are applied
// in-memory at level-up time and persisted via NWNX_Player_SaveCharacter
// from the leveler dialog itself, so there's nothing to do here.

#include "hgll_func_inc"

void main()
{
    object PC = GetExitingObject();
    SetLocalString(PC, "LetoScript", "");
    SetLocalString(PC, "LetoscriptLL", "");
}
