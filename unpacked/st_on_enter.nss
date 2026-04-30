/*
#*#*#*#*#*#*#**#* SPELL TRACKING SYSTEM *#*#*#*#*#*#*#*#*
Spell Tracking System by Archaegeo
December 2002
File: st_on_enter
Purpose: Goes in the OnEnter part of the Modules Events.
         If you already have something there, just include
         the line below.
#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
*/
void main()
{
    ExecuteScript("st_strip_talents",GetEnteringObject());
}
