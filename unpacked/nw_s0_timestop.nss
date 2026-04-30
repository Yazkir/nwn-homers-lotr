//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons in the Area are frozen in time
    except the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// Place the following variable on an area to disable timestop in that area.
// NAME : TIMESTOP_DISABLED  TYPE : Int  VALUE : 1

// If set to zero, the duration will default to 1 + 1d4 rounds. Otherwise, the
// duration will be the number of seconds the variable is changed to.
const int TIME_STOP_OVERRIDE_DURATION = 0;
// ex. const int TIME_STOP_OVERRIDE_DURATION = 9; Timestop lasts 9 seconds.

// Number of seconds before Timestop can be recast after being cast. Countdown
//messages are sent based on this time. Set to 0.0 if you dont want there to
//be any cooldown
const float TIME_STOP_COOLDOWN_TIME = 120.0;

//If set to 1, Timestop will not be usable\
const int TIME_STOP_DISABLE = 1;

#include "x2_inc_spellhook"

int DetermineDuration()
{
    int nDuration = 1 + d4(1);
    float fDuration = RoundsToSeconds(nDuration);
    int nSeconds = FloatToInt(fDuration);
    if (TIME_STOP_OVERRIDE_DURATION != 0) nSeconds = TIME_STOP_OVERRIDE_DURATION;
    return nSeconds;
}

void TimeStopDelay(object oCaster)
{
    float Delay1 = TIME_STOP_COOLDOWN_TIME * 0.25;
    string Message1 = IntToString(FloatToInt(Delay1));
    float Delay2 = TIME_STOP_COOLDOWN_TIME * 0.50;
    string Message2 = IntToString(FloatToInt(Delay2));
    float Delay3 = TIME_STOP_COOLDOWN_TIME * 0.75;
    string Message3 = IntToString(FloatToInt(Delay3));
    SetLocalInt(oCaster, "TIMESTOP_DELAY", 1);
    DelayCommand(Delay1, FloatingTextStringOnCreature("Time Stop Recastable In " + Message3 + " seconds", oCaster, FALSE));
    DelayCommand(Delay2, FloatingTextStringOnCreature("Time Stop Recastable In " + Message2 + " seconds", oCaster, FALSE));
    DelayCommand(Delay3, FloatingTextStringOnCreature("Time Stop Recastable In " + Message1 + " seconds", oCaster, FALSE));
    DelayCommand(TIME_STOP_COOLDOWN_TIME, FloatingTextStringOnCreature("Time Stop Ready", oCaster, FALSE));
    DelayCommand(TIME_STOP_COOLDOWN_TIME, DeleteLocalInt(oCaster, "TIMESTOP_DELAY"));
}
void Timestop(object oCaster)
{
    object oArea = GetArea(oCaster);

    effect eParalyze = EffectCutsceneParalyze();
    int nDuration = DetermineDuration();
    float fDuration = IntToFloat(nDuration);
    object oTarget = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oTarget))    {
        if (GetIsPC(oTarget) == TRUE || GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)        {
            if (GetIsDM(oTarget) == FALSE)            {
                if (oTarget != oCaster)            {
                FloatingTextStringOnCreature("Time Stopped", oTarget, FALSE);
                AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oTarget, fDuration));            }            }         }

                oTarget = GetNextObjectInArea(oArea);     }
}

void TimestopCheck(object oCaster, int nDuration)
{
    if (nDuration == 0) return;

    nDuration = nDuration - 1;
    float fDuration = IntToFloat(nDuration);
    object oArea = GetArea(oCaster);
    location lCaster = GetLocation(oCaster);

    effect eParalyze = EffectCutsceneParalyze();
    object oTarget = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oTarget))    {
        if (GetIsPC(oTarget) == TRUE || GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)        {
            if (GetIsDM(oTarget) == FALSE)            {
                if (oTarget != oCaster)            {

                effect eEffect = GetFirstEffect(oTarget);
                while (GetIsEffectValid(eEffect))            {
                    if (GetEffectType(eEffect) == EFFECT_TYPE_CUTSCENE_PARALYZE)               {
                        SetLocalInt(oTarget, "TIME_STOPPED", 1);                }
                eEffect = GetNextEffect(oTarget);            }

            if (GetLocalInt(oTarget, "TIME_STOPPED") == 0)            {
                FloatingTextStringOnCreature("Time Stopped", oTarget, FALSE);
                AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oTarget, fDuration));            }

            DeleteLocalInt(oTarget, "TIME_STOPPED");            }            }        }

     oTarget = GetNextObjectInArea(oArea);    }

    DelayCommand(1.0, TimestopCheck(oCaster, nDuration));
}

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
   string sName = GetName(OBJECT_SELF);
   if (TIME_STOP_DISABLE == 1) {
        FloatingTextStringOnCreature("This spell does not work on this server", OBJECT_SELF, FALSE);
        return; }


   if (GetLocalInt(GetArea(OBJECT_SELF), "TIMESTOP_DISABLED") == 1 && GetName(OBJECT_SELF) != "Archmage Jezebeth")   {
        FloatingTextStringOnCreature("Time Stop is not permitted in this area", OBJECT_SELF, FALSE);
        return;   }

   if (GetLocalInt(OBJECT_SELF, "TIMESTOP_DELAY") == 1)   {
        FloatingTextStringOnCreature("Timestop is not castable yet", OBJECT_SELF, FALSE);
        return;   }

    if (TIME_STOP_COOLDOWN_TIME != 0.0) {
        string Message = IntToString(FloatToInt(TIME_STOP_COOLDOWN_TIME));
        FloatingTextStringOnCreature("Time Stop Recastable In " + Message + " seconds", OBJECT_SELF, FALSE);
        DelayCommand(0.6, TimeStopDelay(OBJECT_SELF)); }

    //Declare major variables
    location lTarget = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
    int nDuration = DetermineDuration();

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    Timestop(OBJECT_SELF);
    DelayCommand(1.0, TimestopCheck(OBJECT_SELF, nDuration));

}

