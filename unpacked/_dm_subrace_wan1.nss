//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_wan1 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: DM Subrace Wand script ::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script is part of the set of scripts the allow the DM subrace Wand to
// :: to function.

int StartingConditional()
{
    object ChosenTarget = GetLocalObject(GetPCSpeaker(), "_dm_sub_target");
    if(GetIsObjectValid(ChosenTarget) && GetIsPC(ChosenTarget))
    {
       return TRUE;
    }
    return FALSE;
}
