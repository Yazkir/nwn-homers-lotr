 void main()
{
object oTarget;
object oSpawn;
location lTarget;
oTarget = GetWaypointByTag("wellglad1");

lTarget = GetLocation(oTarget);

oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "fightinarena", lTarget);

oTarget = oSpawn;

//Visual effects can't be applied to waypoints, so if it is a WP
//apply to the WP's location instead

int nInt;
nInt = GetObjectType(oTarget);

if (nInt != OBJECT_TYPE_WAYPOINT) DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget));
else DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget)));

oTarget = GetWaypointByTag("wellglad2");

lTarget = GetLocation(oTarget);

oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "spectateinarena", lTarget);

oTarget = oSpawn;

//Visual effects can't be applied to waypoints, so if it is a WP
//apply to the WP's location instead

nInt = GetObjectType(oTarget);

if (nInt != OBJECT_TYPE_WAYPOINT) DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget));
else DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget)));

ActionSpeakString("Join the Tournament! There are two portals in the Well of Eru - one allows you to spectate the fight, and the other lets you join the fray. You have 5 minutes to enter the fight.", TALKVOLUME_SHOUT);
DelayCommand(5.0, ActionSpeakString("Rules: No Timestop, Greater Sanctuary, Disarm, pickpocketing, or healing.", TALKVOLUME_SHOUT));
DelayCommand(120.0, ActionSpeakString("You have 3 minutes left to join.", TALKVOLUME_SHOUT));
DelayCommand(240.0, ActionSpeakString("One minute left! Join the fight by going through the portal in the Well.", TALKVOLUME_SHOUT));
DelayCommand(270.0, ActionSpeakString("30 seconds!", TALKVOLUME_SHOUT));
DelayCommand(285.0, ActionSpeakString("15 seconds! This is the last warning.", TALKVOLUME_SHOUT));
DelayCommand(300.0, ActionSpeakString("Time's up. No more contestants will be admitted into the fight.", TALKVOLUME_SHOUT));

{
object oTarget3 = GetObjectByTag("FightinArena");
DelayCommand(300.0, DestroyObject(oTarget3, 0.0));
object oTarget4 = GetObjectByTag("SpectateinArena");
DelayCommand(600.0, DestroyObject(oTarget4, 0.0));
}
}
