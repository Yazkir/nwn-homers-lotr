//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_wan6 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: DM Subrace Wand script ::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script is part of the set of scripts the allow the DM subrace Wand to
// :: to function.

#include "sha_subr_methds"
void main()
{
     object oDM = GetPCSpeaker();

     SendMessageToPC(oDM, "-------- Shayan's Subrace Engine --------");
     SHA_SendSubraceMessageToPC(oDM, "Current Engine Version: " + SUBRACE_ENGINE_VERSION);
     if(ENABLE_LETO)
     {
         SHA_SendSubraceMessageToPC(oDM, "Checking NWNX2-LETO Plugin Status...");
         if(LetoPingPong())
         {
            SHA_SendSubraceMessageToPC(oDM, "NWNX2-LETO Plugin Enabled, and functioning!");
         }
         else
         {
            SHA_SendSubraceMessageToPC(oDM, "ERROR! NWNX2-LETO is not functioning! Make sure you have installed it correctly.");
         }
     }
     else
     {
          SHA_SendSubraceMessageToPC(oDM, "NWNX2-Leto support is currently disabled.");
     }
}
