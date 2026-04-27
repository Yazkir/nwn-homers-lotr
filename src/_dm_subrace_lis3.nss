//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_lis3 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: DM Subrace Wand script ::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script is part of the set of scripts the allow the DM subrace Wand to
// :: to function.

int StartingConditional()
{
    object Helper = GetNearestObjectByTag("DM_SUBRACE_HELPER");
    if(Helper == OBJECT_INVALID)
    {
       return 0;
    }
    string Subrace = GetLocalString(Helper, "DM_SUBRACE_CHOSEN");
    SetCustomToken(8686, Subrace);
    SetLocalInt(OBJECT_SELF, "DM_CHOICE", 1);
    return TRUE;
}
