/*
#*#*#*#*#*#*#**#* SPELL TRACKING SYSTEM *#*#*#*#*#*#*#*#*
Spell Tracking System by Archaegeo
December 2002
File: st_on_rest
Purpose: Goes in the OnPlayerRest part of the Modules Events.
         If you already have something there, just include
         the line below.
#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
*/
void main()
{
    if(GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
        ExecuteScript("st_resetspells", GetLastPCRested());
    if(GetLastRestEventType()==REST_EVENTTYPE_REST_CANCELLED)
        ExecuteScript("st_strip_talents", GetLastPCRested());
}
