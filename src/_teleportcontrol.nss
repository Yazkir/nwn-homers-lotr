void main()
{


object oPC = GetPCSpeaker();

object oTarget;
location lTarget;
oTarget = GetWaypointByTag("pvp");

AssignCommand(oPC, ClearAllActions());

AssignCommand(oPC, ActionJumpToLocation(lTarget));

effect eAppear1 = EffectDisappear(VFX_FNF_LOS_EVIL_30);
effect eVis1 = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD );
effect eVis2 = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis1, oPC);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis2, oPC);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAppear1, oPC,3.0);
DelayCommand(1.0,AssignCommand (oPC, ActionJumpToObject(GetWaypointByTag("control"))));
}

