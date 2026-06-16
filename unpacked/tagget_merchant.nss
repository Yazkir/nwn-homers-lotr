#include "store_appr_inc"
//::///////////////////////////////////////////////
//:: FileName tagget_merchant
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/14/2002 6:57:08 PM
//:://////////////////////////////////////////////
void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("NW_STOREWEAP001");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStoreAppr(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
