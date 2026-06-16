#include "store_appr_inc"
//::///////////////////////////////////////////////
//:: FileName at_005
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/16/2002 9:36:23 PM
//:://////////////////////////////////////////////
void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("NW_STORETHIEF001");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStoreAppr(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
