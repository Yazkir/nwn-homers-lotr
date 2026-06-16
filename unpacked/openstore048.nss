#include "store_appr_inc"
void main()
{
    object oStore = GetNearestObjectByTag("X2_STORETEMPL002");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
    {
        OpenStoreAppr(oStore, GetPCSpeaker());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}