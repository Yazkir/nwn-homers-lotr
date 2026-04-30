#include "my_createshield"

void main()
{
    object oPC = GetLastOpenedBy();
    object oContainer = OBJECT_SELF;
    int nMaxLevel = 12;

    CreateShield(oContainer,oPC,nMaxLevel);

}
