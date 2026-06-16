#include "store_appr_inc"
void main()
{
    object oStore = GetNearestObjectByTag("NW_STORGENRAL002");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
    {
        OpenStoreAppr(oStore, GetPCSpeaker(), TRUE);
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}