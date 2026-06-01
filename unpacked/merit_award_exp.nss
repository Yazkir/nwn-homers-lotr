// merit_award_exp — Reply action: award an Exploit Report merit to selected player.
#include "merit_db"
void main()
{
    object oDM    = GetPCSpeaker();
    string sCdKey = GetLocalString(oDM, "merit_sel_cdkey");
    string sName  = GetLocalString(oDM, "merit_sel_name");

    Merit_AwardExploit(sCdKey);

    SendMessageToPC(oDM, "[Merit] Awarded Exploit Report (+3) to " + sName + ".");

    object oTarget = GetFirstPC();
    while (GetIsObjectValid(oTarget))
    {
        if (GetPCPublicCDKey(oTarget) == sCdKey)
        {
            SendMessageToPC(oTarget,
                "[Merit] A DM has logged your exploit report. Thank you!");
            break;
        }
        oTarget = GetNextPC();
    }

    SetCustomToken(5011, sName);
}
