#include "my_createbelt"

void main()
{
    object oPC = GetLastOpenedBy();
    object oContainer = OBJECT_SELF;
    int nMaxLevel = 12;

    CreateBelt(oContainer,oPC,nMaxLevel);

}
