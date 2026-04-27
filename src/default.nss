//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::File Name: default ::::::::::::::::::::::::::::::::::
//::::::::::::::::::::: OnPlayerHearbeat script ::::::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// Description: This script is the Player HeartBeat script. Even though there is no
//              such module Event, this script is executed by the NWN engine every round
//              on every player in the module.
//              I have used it to check and apply most of the subrace properties.
//              THIS SCRIPT IS ESSENTIAL FOR Shayan's Subrace Engine TO FUNCTION.
//

#include "sha_subr_methds"
void main()
{
    SubraceHeartbeat(OBJECT_SELF);
}
