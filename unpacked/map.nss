 // if this code were placed in the OnEnter event
// of an area, the entire map would be revealed to the player
// even if they have never been there before.
void main()
{
    // Keep creatures in their spawn area (anti-kiting); see leash_to_area.nss.
    ExecuteScript("leash_to_area", OBJECT_SELF);

   object oPlayer = GetEnteringObject();
   if (GetIsObjectValid(oPlayer) & GetIsPC(oPlayer))
   {
      object oArea = GetArea(oPlayer);
      ExploreAreaForPlayer(oArea, oPlayer);
   }
}

