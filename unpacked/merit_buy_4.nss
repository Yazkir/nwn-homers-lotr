// merit_buy_4 — Reply action: spend 35 merit on Reward 4 Placeholder.
#include "merit_db"
void main()
{
    object oPC    = GetPCSpeaker();
    string sCdKey = GetPCPublicCDKey(oPC);
    Merit_Spend(sCdKey, 35);
    Merit_SetNpcTokens(oPC);
    SendMessageToPC(oPC,
        "[Merit] You spent 35 merit. Reward 4 Placeholder: coming soon!");
}
