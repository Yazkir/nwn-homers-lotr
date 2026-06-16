//::///////////////////////////////////////////////
//:: FileName dlg_chaz_at1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/8/2006 4:38:52 AM
//:://////////////////////////////////////////////
#include "store_appr_inc"

void main()
{

    // Either open the store with that tag or let the user know that no store exists.
    object oStore = GetNearestObjectByTag("ms_chaz_store");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
        OpenStoreAppr(oStore, GetPCSpeaker(), TRUE);
    else
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
