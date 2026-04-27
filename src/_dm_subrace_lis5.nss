//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::::::::File Name: _dm_subrace_lis5 :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: DM Subrace Wand script ::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// :: This script is part of the set of scripts the allow the DM subrace Wand to
// :: to function.

// :: Note if you are using NWNX databases, then comment line 28 and uncomment
// :: line 29.

#include "sha_subr_methds"
void main()
{
   object ChosenTarget = GetLocalObject(GetPCSpeaker(), "_dm_sub_target");
   DeleteSubraceInfoOnPC(ChosenTarget);

   object Helper = GetNearestObjectByTag("DM_SUBRACE_HELPER");
    if(Helper == OBJECT_INVALID)
    {
       return ;
    }
    string Subrace = GetLocalString(Helper, "DM_SUBRACE_CHOSEN");
    SetSubRace(ChosenTarget, CapitalizeString(Subrace));
    Subrace = GetStringLowerCase(Subrace);
    DelayCommand(5.5, SHA_SendSubraceMessageToPC(ChosenTarget, "Switching sub-races to: " + CapitalizeString(Subrace) + "...", TRUE));
    DelayCommand(5.6, SetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + "_" + Subrace, SUBRACE_ACCEPTED, ChosenTarget));
    DelayCommand(6.0, LoadSubraceInfoOnPC(ChosenTarget, Subrace));
    DelayCommand(7.0, ApplyPermanentSubraceSpellResistance(Subrace, ChosenTarget));
    DelayCommand(8.5, ApplyPermanentSubraceAppearance(Subrace, ChosenTarget));
    DelayCommand(15.0, CheckIfCanUseEquipedWeapon(ChosenTarget));
    DelayCommand(18.5, CheckIfCanUseEquippedArmor(ChosenTarget));
    DelayCommand(21.5, SHA_SendSubraceMessageToPC(ChosenTarget, "Sub-race was switched!", TRUE));
    return;
}
