#include "hgll_func_inc"

void main()
{
    object PC = GetExitingObject();
    object M = GetModule();

    string Script = GetLocalString(PC, "LetoScript");

    if( Script != "" )
        {
        SetLocalString(PC, "LetoScript", "");
        LetoScript(Script);
        }
}
