#include "store_appr_inc"
//::///////////////////////////////////////////////
//:: FileName at_020
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/8/2002 12:07:27 AM
//:://////////////////////////////////////////////
void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("NW_STOREWEAP003");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStoreAppr(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
