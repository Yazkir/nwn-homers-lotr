// OnExit of Area
void PurgeCreatures();
void main()
{
   object oPC = GetExitingObject();
   // if it's a PC, wait 10 seconds then start purge
   if(GetIsPC(oPC))
   {
      DelayCommand(10.0f, PurgeCreatures());
   }
}
void PurgeCreatures()
{
   // We'll cycle through all PC's and check if they are in the area
   //  If we find one, we'll return without doing the purge
   object oArea = GetArea(OBJECT_SELF);
   object oPC = GetFirstPC();
   while (oPC != OBJECT_INVALID)
   {
      if (GetArea(oPC) == oArea)
         return;
      oPC = GetNextPC();
   }

   // Cycle through all objects and Destroy Encounter creatures
   object oCreature = GetFirstObjectInArea(oArea);
   while (oCreature != OBJECT_INVALID)
   {
      if (GetIsEncounterCreature(oCreature))
         DestroyObject(oCreature);
      oCreature = GetNextObjectInArea(oArea);
   }
}
