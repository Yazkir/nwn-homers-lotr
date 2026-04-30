//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_lis4 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: DM Subrace Wand script ::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script is part of the set of scripts the allow the DM subrace Wand to
// :: to function.
#include "sha_subr_methds"

void main()
{
   if(!GetLocalInt(OBJECT_SELF, "DM_CHOICE"))
   {
       object oListener = CreateObject(OBJECT_TYPE_CREATURE, "dmsubracehelper", GetLocation(OBJECT_SELF));
       SetLocalObject(oListener, "DM_SUMMONER", OBJECT_SELF);
       DelayCommand(58.0, SetImmortal(oListener, TRUE));
       DelayCommand(59.0, SetPlotFlag(oListener, TRUE));
       DelayCommand(60.0, DestroyObject(oListener));
   }
   else
   {
      object oListener = GetObjectByTag("DM_SUBRACE_HELPER");
      DeleteLocalInt(OBJECT_SELF, "DM_CHOICE");
      SetImmortal(oListener, TRUE);
      SetPlotFlag(oListener, TRUE);
      DestroyObject(oListener);
   }
}
