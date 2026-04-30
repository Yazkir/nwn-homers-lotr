void main()
{


object oPC = GetPCSpeaker();
string sPC = GetName(oPC);

SpeakString(sPC  +  "has been sent to jail for being lame. The player has been marked for such, and will not be able to properly interact within the confines of Middle Earth until his punishment has been decided/enforced by a Dungeon Master. He will remain imprisoned for a short period of time, then released into society for his 'parole' so-to-speak. This act has deemed the player in question deviod of any pvp pules that are carried out against him, for a period of no more than one full game day from now.", TALKVOLUME_SHOUT);

object oTarget;
location lTarget;
oTarget = GetWaypointByTag("secondchance");

lTarget = GetLocation(oTarget);

//only do the jump if the location is valid.
//though not flawless, we just check if it is in a valid area.
//the script will stop if the location isn't valid - meaning that
//nothing put after the teleport will fire either.
//the current location won't be stored, either

if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());

DelayCommand(600.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

oTarget = oPC;

int nInt;
nInt = GetObjectType(oTarget);

if (nInt != OBJECT_TYPE_WAYPOINT) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget);
else ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget));

}
