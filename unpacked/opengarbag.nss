#include "store_appr_inc"
// #include "nw_i0_plot"
void main()
{
    object oStore = GetNearestObjectByTag("cirithmerch");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
    {
        OpenStoreAppr(oStore, GetPCSpeaker());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}
