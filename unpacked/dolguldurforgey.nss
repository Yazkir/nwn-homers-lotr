#include "store_appr_inc"
void main()
{
    object oStore = GetNearestObjectByTag("NW_STOREBAR01");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
    {
        OpenStoreAppr(oStore, GetPCSpeaker());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}