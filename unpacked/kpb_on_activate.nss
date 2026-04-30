//::///////////////////////////////////////////////
//:: KBP (Kittrell's Persistent Banking) Fixed
//:: OnActivateItem + Modified Original Bioware
//:: Hordes of the Undertide OnActivateItem
//:: Script to Fix Compatibility Issues
//:: kpb_on_activate.nss
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnItemActivate Event
*/
//:://////////////////////////////////////////////
//:: Modified By: Brian J. Kittrell / Tethyr
//::    Darknight
//:: Created On: 2004-2-14
//:://////////////////////////////////////////////

#include "x2_inc_switches"
void main()
{
     object oItem = GetItemActivated();
     object oUser=GetItemActivator();
     location lLoc=GetItemActivatedTargetLocation();
     string sTag=GetTag(oItem);

     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACTIVATE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }

     }

    if(sTag=="kpbwand")
    {
        if (GetIsDM(oUser) == TRUE)
        {
        AssignCommand(oUser, ActionStartConversation(oUser, "kpb_wand", TRUE));
        }
        else
        {
        DestroyObject(oItem);
        SendMessageToPC(oUser, "I am not an immortal, and I cannot use that item!");
        }
    }

    if (oItem == GetObjectByTag("kpb_timetool"))
    AssignCommand(oUser, ActionStartConversation(oUser, "kpb_timetool", FALSE));
}
