/////////////////////////////////////////////////////////////////////////////
// Weapon Warning Script                                                   //
// written by bigbluepaw @ NeverwinterConnections                          //
// bigbluepaw@yahoo.com                                                    //
/////////////////////////////////////////////////////////////////////////////

void WarnRaceNearby(string sTag, int iRace, float fDistance,int nVfx)
{
    // Set all variables required for checking...
    object oPC = GetFirstPC();
    object oWeapon = GetObjectByTag(sTag);
    object oSPC;
    int ndex = 1;

    // Only run the rest of the script against PCs.
    while (GetIsObjectValid(oPC))
        {
            // Only run the rest of the script of the tag of the item specified is in the lefthand or righthand item slot.
            if (GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC)) == sTag | GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)) == sTag)
                {
                // Find the nearest critter.
                oSPC = GetNearestObject(OBJECT_TYPE_CREATURE,oPC,ndex);
                // Only run the rest of the script if the critteris valid.
                while(GetIsObjectValid(oSPC))
                    {
                        // Only run the rest of the script if the critter is within the distance specified and the racial type specified.
                        if (GetDistanceBetween(oSPC,oPC) < fDistance && GetRacialType(oSPC) == iRace)
                            {
                            // Apply the visual effects.
                            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(nVfx),oWeapon,RoundsToSeconds(1));
                            }
                        // Keep indexing until you have gone through all the critters in the area.
                        ndex++;
                        oSPC = GetNearestObject(OBJECT_TYPE_CREATURE,oPC,ndex++);
                    }
                }
            // Keep indexing through the PCs until you have done it for all of them.
            oPC = GetNextPC();
        }
}
