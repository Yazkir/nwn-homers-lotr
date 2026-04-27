#include "my_createring"

void main()
{
    object oPC = GetLastOpenedBy();
    object oContainer = OBJECT_SELF;
    int nMaxLevel = 12;

    CreateRing(oContainer,oPC,nMaxLevel);

}
