// merit_buy_5 — Reply action: spend 50 merit on Reward 5 Placeholder.
#include "merit_db"
void main()
{
    object oPC    = GetPCSpeaker();
    string sCdKey = GetPCPublicCDKey(oPC);
    Merit_Spend(sCdKey, 50);
    Merit_SetNpcTokens(oPC);
    SendMessageToPC(oPC,
        "[Merit] You spent 50 merit. Reward 5 Placeholder: coming soon!");
}
