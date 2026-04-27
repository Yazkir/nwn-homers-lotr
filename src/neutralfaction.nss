//::///////////////////////////////////////////////
//:: FileName sc_034
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/20/2002 4:38:58 PM
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on the player's alignment
    if(GetAlignmentGoodEvil(GetPCSpeaker()) == ALIGNMENT_EVIL)
        return FALSE;
     if(GetAlignmentGoodEvil(GetPCSpeaker()) == ALIGNMENT_GOOD)
        return FALSE;
    return TRUE;
}

