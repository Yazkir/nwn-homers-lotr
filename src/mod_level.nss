void main()
{
object oPC = GetPCLevellingUp();
string oPCname = GetName(oPC);


   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MASS_HEAL), oPC);
//   SpeakString(( oPCname + " has advanced a level!"), TALKVOLUME_SHOUT);
}

