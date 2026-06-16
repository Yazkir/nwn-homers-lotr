#include "store_appr_inc"
void main()
{
    object oPlayer;
    object oStore;

    oPlayer = GetPCSpeaker();
    oStore = GetNearestObjectByTag("NW_STOREBAR01");
    OpenStoreAppr(oStore,oPlayer);
}
