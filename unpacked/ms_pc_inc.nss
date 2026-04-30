// Markshire Persistent Chest System (MPCS)
// Thrym of Markshire
//
// MPCS Function Library
//
///////////////////////////////////////////

// INCLUDES ///////////////////////////////

#include "x0_i0_position"
#include "x0_i0_henchman"


// FUNCTION DECLARIONS ////////////////////

// Uncouple from PC
// Store The Chest in the DB
// Destroy the Chest in Game
void ms_Store_Chest(object oPlayer, object oChest, string sKey);

// Search the area for a matching Chest
// If there is one already return TRUE
int ms_Chest_Area_Check(object oPlayer, string sKey);

// Retrieve the Chest from the DB
// Set it to Face the PC
void ms_Retrieve_Chest(object oPlayer, string sKey, location lTarget);


// FUNCTIONS //////////////////////////////

void ms_Store_Chest(object oPlayer, object oChest, string sKey)
{
    FireHenchman(oPlayer, oChest);
    StoreCampaignObject("FH_MPCS", sKey, oChest, oPlayer);
    SendMessageToPC(oPlayer, "Storing the Chest.");
    SendMessageToPC(oPlayer, "Give it a few moments. Please be patient.");
    DestroyObject(oChest);
    effect eSpawn1 = EffectVisualEffect(VFX_FNF_PWSTUN);
    effect eSpawn2 = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
    effect eSpawn  = EffectLinkEffects(eSpawn1, eSpawn2);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpawn, GetLocation(oChest));
    ExportSingleCharacter(oPlayer);

}


int ms_Chest_Area_Check(object oPlayer, string sKey)
{
    object oChest = GetFirstObjectInArea(GetArea(oPlayer));

    string sSearchID;

    // Check for Chest Already Spawned
    while (GetIsObjectValid(oChest))
    {
        sSearchID = GetLocalString(oChest, "OWNER_ID");

        if (sKey == sSearchID) return TRUE;

        oChest = GetNextObjectInArea(GetArea(oPlayer));
    }

    return FALSE;
}

void ms_Retrieve_Chest(object oPlayer, string sKey, location lTarget)
{
    string sCDKey = GetPCPublicCDKey(GetPCSpeaker());
    object oTarget = RetrieveCampaignObject("FH_MPCS", sKey, lTarget, OBJECT_INVALID, oPlayer);
    TurnToFaceObject(oPlayer, oTarget);
    SendMessageToPC(oPlayer, "Retrieving the Chest.");
    SendMessageToPC(oPlayer, "Give it a few moments. Please be patient.");
    SetLocalString(oTarget, "OWNER_ID", sCDKey);
}
