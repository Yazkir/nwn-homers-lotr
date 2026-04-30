//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//::::::::::::::::::: File Name: _dm_subrace_wand ::::::::::::::::::::::::::::::
//:::::::::::::::::::::    DM Subrace Wand    ::::::::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
//:: This script is not an esstential part of Shayan's Subrace Engine.
//
//::This script activates the DM Subrace Wand.

#include "sha_subr_methds"
void main()
{
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();
   object oWand = GetItemActivated();
   string sTag = GetTag(oWand);

   if(sTag != "_dm_subrace_wand")
   {  return; }
   if(GetIsObjectValid(oTarget))
   {
      SetLocalObject(oPC, "_dm_sub_target", oTarget);
   }
   AssignCommand(oPC, ActionStartConversation(oPC, "_subr_dm_conv", TRUE, FALSE));
}
