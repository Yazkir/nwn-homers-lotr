//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_wan2 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: DM Subrace Wand script ::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script is part of the set of scripts the allow the DM subrace Wand to
// :: to function.

#include "sha_subr_methds"
void main()
{
    object ChosenTarget = GetLocalObject(GetPCSpeaker(), "_dm_sub_target");
    ReadSubraceInformation(GetStringLowerCase(GetSubRace(ChosenTarget)), GetPCSpeaker(), ChosenTarget);

}
