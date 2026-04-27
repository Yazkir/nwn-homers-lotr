void main()
{
    object oPlayer;
    object oStore;

    oPlayer = GetPCSpeaker();
    oStore = GetNearestObjectByTag("NW_STOREBAR01");
    OpenStore(oStore,oPlayer);
}
