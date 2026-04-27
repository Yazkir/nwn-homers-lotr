// Markshire Persistent Chest System (MPCS)
// Thrym of Markshire
//
// Chest Proximity Sensor
//
// If the chest and the PC are farther then 10.0 apart
// the chest will store itself away automatically.
//
// Safety measure for forgetful types.
//

#include "ms_pc_inc"

void main()
{
    object oPC = GetMaster();

    switch (GetDistanceBetween(OBJECT_SELF, oPC) > 10.0)
    {
        case TRUE:  ms_Store_Chest(oPC, OBJECT_SELF, GetLocalString(OBJECT_SELF, "OWNER_ID")); break;
        case FALSE: DelayCommand(30.0, ExecuteScript("ms_pc_prox", OBJECT_SELF)); break;
    }
}
