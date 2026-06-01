// merit_buy_2 — Reply action: spend 10 merit on Reward 2 Placeholder.
#include "merit_db"
void main()
{
    object oPC    = GetPCSpeaker();
    string sCdKey = GetPCPublicCDKey(oPC);
    Merit_Spend(sCdKey, 10);
    Merit_SetNpcTokens(oPC);
    SendMessageToPC(oPC,
        "[Merit] You spent 10 merit. Reward 2 Placeholder: coming soon!");
}
