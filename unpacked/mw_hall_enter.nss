//::///////////////////////////////////////////////
//:: mw_hall_enter — Hall of Legends OnEnter handler.
//::
//:: When a PC enters, for each guide the PC has unlocked: if the live
//:: NPC isn't yet spawned, destroy the placeholder statue and spawn the
//:: world-form creature at the statue's location. The swap is permanent
//:: server-side (next PC sees the live guide) — acceptable for a public
//:: hub area.
//:://////////////////////////////////////////////
#include "mw_unlock_inc"

void TrySwap(string sGuide)
{
    string sLiveTag = "mw_" + sGuide + "_w";
    if (GetIsObjectValid(GetObjectByTag(sLiveTag))) return;

    string sStatueTag = "mw_stat_" + sGuide;
    object oStatue = GetObjectByTag(sStatueTag);
    if (!GetIsObjectValid(oStatue)) return;

    location lLoc = GetLocation(oStatue);
    DestroyObject(oStatue);
    object oNew = CreateObject(OBJECT_TYPE_CREATURE, sLiveTag, lLoc);
    // Switch the Hall instance to the post-unlock dialogue.
    if (GetIsObjectValid(oNew))
        SetDialogResRef(oNew, "mw_" + sGuide + "_l");
}

void main()
{
    object oEntering = GetEnteringObject();
    if (!GetIsPC(oEntering)) return;

    int i;
    for (i = 0; i < MW_ROSTER_SIZE; i++)
    {
        string sGuide = MW_GuideAt(i);
        if (MW_IsUnlocked(oEntering, sGuide))
            TrySwap(sGuide);
    }
}
