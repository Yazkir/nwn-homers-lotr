#include "store_appr_inc"
void main()
{
    object oStore = GetNearestObjectByTag("watchmans4real");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
    {
        OpenStoreAppr(oStore, GetPCSpeaker(), TRUE);
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}