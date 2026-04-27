void main()
{
int iRand = Random(22);
string sWPFirst = "WP_LegolasGreenleaf";
string sWPSecond = IntToString(iRand);
string sMoveTo = sWPFirst+sWPSecond;
object oMoveTo = GetWaypointByTag(sMoveTo);
object oVictim = GetLastPerceived();
location lstart = GetLocation(OBJECT_SELF);
location ltarget = GetLocation(oMoveTo);
effect eVis = EffectVisualEffect(18);
effect eVis1 = EffectVisualEffect(29);
effect eVis2 = EffectVisualEffect(74);
effect eDamage = EffectDamage(d100(2),DAMAGE_TYPE_SONIC ,DAMAGE_POWER_PLUS_FIVE);

DelayCommand(0.0f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF,6.0)));
DelayCommand(0.5f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, OBJECT_SELF,6.0)));
DelayCommand(1.0f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, OBJECT_SELF,6.0)));
DelayCommand(1.5f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oMoveTo,6.0)));
DelayCommand(2.2f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, oMoveTo,6.0)));
DelayCommand(2.5f,(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oMoveTo,6.0)));

if (GetArea(oVictim) == GetArea(OBJECT_SELF) && GetIsPC(oVictim))
{
DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage, oVictim));
}
ActionJumpToObject(oMoveTo, TRUE);
ActionAttack(oVictim, FALSE);
DelayCommand(5.6f,(ClearAllActions()));
}
