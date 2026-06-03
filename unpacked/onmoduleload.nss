//On module load
//Example of OnLoad Script


//***************************************************************************
// CONSTANTS



//***************************************************************************


//PCs Autosaving
#include "pc_export_inc"
#include "color"
#include "nwnx_admin"
#include "x2_inc_switches"


void main()
{

//****************************************************************************
//PCs Autosaving function
pc_export_onmoduleload();

// Force max HP on every level-up, server-wide.
NWNX_Administration_SetPlayOption(NWNX_ADMINISTRATION_OPTION_USE_MAX_HITPOINTS, TRUE);
//----------------------------------------------------------------------------

// Enable tag-based scripting for item events (e.g. Rod of Fast Buffing)
SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);

// Spawn Meaningwave NPCs at their designated waypoints
ExecuteScript("mw_spawn", GetModule());

// Color tokens for dialogue text (used in bank XP retirement warnings)
// CUSTOM6100 = red, CUSTOM6101 = yellow, CUSTOM6102 = close
SetCustomToken(6100, COLOR_RED);
SetCustomToken(6101, COLOR_YELLOW);
SetCustomToken(6102, COLOR_END);

}   //end of main
