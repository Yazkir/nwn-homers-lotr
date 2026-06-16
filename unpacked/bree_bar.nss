#include "store_appr_inc"
//::///////////////////////////////////////////////
//:: FileName bree_bar
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/15/2002 12:34:03 PM
//:://////////////////////////////////////////////
void main()
{

	// Either open the store with that tag or let the user know that no store exists.
	object oStore = GetNearestObjectByTag("NW_STOREBAR01");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStoreAppr(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
