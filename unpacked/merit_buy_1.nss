// merit_buy_1 — Reply action: spend 5 merit on Reward 1 Placeholder.
#include "merit_db"
void main()
{
    object oPC    = GetPCSpeaker();
    string sCdKey = GetPCPublicCDKey(oPC);
    Merit_Spend(sCdKey, 5);
    Merit_SetNpcTokens(oPC);
    SendMessageToPC(oPC,
        "[Merit] You spent 5 merit. Reward 1 Placeholder: coming soon!");
}
