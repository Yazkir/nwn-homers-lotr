#include "nw_i0_plotwizard"
#include "bdm_include"
void main()
{
    // PLOT WIZARD MANAGED CODE BEGINS
    // PLOT WIZARD MANAGED CODE ENDS
    object oItem = GetModuleItemAcquired();

    if (GetIsPC(GetItemPossessor(oItem)))
    {
        SetLocalInt(oItem, "PCItem", 1);
    }
    BDM_ModuleItemAcquired();

}
