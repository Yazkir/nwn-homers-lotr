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

void TrySwap(string sGuide, object oHallArea)
{
    string sLiveTag = "mw_" + sGuide + "_w";
    object oExisting = GetObjectByTag(sLiveTag);
    // Only skip if the guide is already present in THIS area (GetObjectByTag
    // searches module-wide, so the world-spawn in e.g. Rivendell would
    // otherwise prevent the Hall placement).
    if (GetIsObjectValid(oExisting) && GetArea(oExisting) == oHallArea) return;

    string sStatueTag = "mw_stat_" + sGuide;
    object oStatue = GetObjectByTag(sStatueTag);
    if (!GetIsObjectValid(oStatue)) return;

    location lLoc = GetLocation(oStatue);
    DestroyObject(oStatue);
    CreateObject(OBJECT_TYPE_CREATURE, sLiveTag, lLoc);
}

void main()
{
    object oEntering = GetEnteringObject();
    if (!GetIsPC(oEntering)) return;

    object oHallArea = GetArea(oEntering);
    int i;
    for (i = 0; i < MW_ROSTER_SIZE; i++)
    {
        string sGuide = MW_GuideAt(i);
        if (MW_IsUnlocked(oEntering, sGuide))
            TrySwap(sGuide, oHallArea);
    }
}
