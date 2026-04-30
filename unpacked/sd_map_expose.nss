//::///////////////////////////////////////////////
//:: Name Map Exposer.
//:: FileName sd_map_expose
//:: Copyright (c) 2003 Sean Darrenkamp
//:://////////////////////////////////////////////
/*
Map out an area for a player.
*/
//:://////////////////////////////////////////////
//:: Created By: Sean Darrenkamp
//:: Created On: April 22, 2003
//:://////////////////////////////////////////////

// Main code block.
void main()
{
   object oPlayer = GetEnteringObject();
   object oArea = GetArea(oPlayer);
   ExploreAreaForPlayer(oArea,oPlayer);
}
