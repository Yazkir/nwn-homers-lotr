//::///////////////////////////////////////////////
//:: Name: tr_cond_vld_lvl
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Evaluates last command typed by PC for a
     number for level adjustment.
*/
//:://////////////////////////////////////////////
//:: Created By: Cylvia
//:: Created On: 1-2-2004
//:://////////////////////////////////////////////

// this will show up if no proper number was specified.
int StartingConditional()
{
string sCheck = GetLocalString(OBJECT_SELF,"trainer evaluate");
SetCustomToken(7777,sCheck);
return TRUE;

}
