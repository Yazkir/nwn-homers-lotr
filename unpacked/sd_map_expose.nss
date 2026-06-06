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
    // Keep creatures in their spawn area (anti-kiting); see leash_to_area.nss.
    ExecuteScript("leash_to_area", OBJECT_SELF);

   object oPlayer = GetEnteringObject();
   object oArea = GetArea(oPlayer);
   ExploreAreaForPlayer(oArea,oPlayer);
}
