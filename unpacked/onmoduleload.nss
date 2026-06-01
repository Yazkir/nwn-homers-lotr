//On module load
//Example of OnLoad Script


//***************************************************************************
// CONSTANTS



//***************************************************************************


//PCs Autosaving
#include "pc_export_inc"
#include "color"
#include "nwnx_admin"


void main()
{

//****************************************************************************
//PCs Autosaving function
pc_export_onmoduleload();

// Force max HP on every level-up, server-wide.
NWNX_Administration_SetPlayOption(NWNX_ADMINISTRATION_OPTION_USE_MAX_HITPOINTS, TRUE);
//----------------------------------------------------------------------------

// Spawn Meaningwave NPCs at their designated waypoints
ExecuteScript("mw_spawn", GetModule());

// Color tokens for dialogue text (used in bank XP retirement warnings)
// CUSTOM6100 = red, CUSTOM6101 = yellow, CUSTOM6102 = close
SetCustomToken(6100, COLOR_RED);
SetCustomToken(6101, COLOR_YELLOW);
SetCustomToken(6102, COLOR_END);

}   //end of main
