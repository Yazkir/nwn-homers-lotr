#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    if (nEvent != X2_ITEM_EVENT_ACTIVATE)
    {
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
        return;
    }

    object oUser   = GetItemActivator();
    object oTarget = GetItemActivatedTarget();

    if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || !GetIsPC(oTarget))
    {
        FloatingTextStringOnCreature(
            "Rod of Fast Lore: invalid target — must be used on a player character.",
            oUser, FALSE);
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        return;
    }

    int    nLore      = GetSkillRank(SKILL_LORE, oUser);
    string sSuccesses = "";
    string sFailures  = "";
    int    nIdentified = 0;
    int    nFailed     = 0;

    object oItem = GetFirstItemInInventory(oTarget);
    while (GetIsObjectValid(oItem))
    {
        if (!GetIdentified(oItem))
        {
            string sTypeName = GetName(oItem);
            int    nDC       = GetGoldPieceValue(oItem) / 100 + 1;
            int    nCheck    = d20() + nLore;

            if (nCheck >= nDC)
            {
                SetIdentified(oItem, TRUE);
                sSuccesses += "\n  " + sTypeName + " -> " + GetName(oItem);
                nIdentified++;
            }
            else
            {
                sFailures += "\n  " + sTypeName;
                nFailed++;
            }
        }
        oItem = GetNextItemInInventory(oTarget);
    }

    string sHeader;
    string sTargetHeader;
    if (oUser == oTarget)
    {
        sHeader = "Rod of Fast Lore: scanned your inventory (Lore " + IntToString(nLore) + ").";
        sTargetHeader = sHeader;
    }
    else
    {
        sHeader       = "Rod of Fast Lore: scanned " + GetName(oTarget) + "'s inventory (Lore " + IntToString(nLore) + ").";
        sTargetHeader = "Rod of Fast Lore: " + GetName(oUser) + " scanned your inventory (Lore " + IntToString(nLore) + ").";
    }

    string sBody = " Identified (" + IntToString(nIdentified) + "):"
                 + (nIdentified > 0 ? sSuccesses : " none")
                 + "\n Failed (" + IntToString(nFailed) + "):"
                 + (nFailed > 0 ? sFailures : " none");

    SendMessageToPC(oUser, sHeader + "\n" + sBody);
    if (oUser != oTarget)
        SendMessageToPC(oTarget, sTargetHeader + "\n" + sBody);

    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
}
