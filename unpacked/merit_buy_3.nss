// merit_buy_3 — Reply action: spend 20 merit on Reward 3 Placeholder.
#include "merit_db"
void main()
{
    object oPC    = GetPCSpeaker();
    string sCdKey = GetPCPublicCDKey(oPC);
    Merit_Spend(sCdKey, 20);
    Merit_SetNpcTokens(oPC);
    SendMessageToPC(oPC,
        "[Merit] You spent 20 merit. Reward 3 Placeholder: coming soon!");
}
