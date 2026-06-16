#include "store_appr_inc"
//::///////////////////////////////////////////////
//:: FileName at_053
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/21/2002 6:13:25 PM
//:://////////////////////////////////////////////
void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("NW_STORETHIEF002q");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStoreAppr(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
