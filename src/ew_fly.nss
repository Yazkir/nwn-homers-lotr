/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
effect Dis  = EffectDisappear();
effect App  = EffectAppear();
effect Vis = EffectVisualEffect(VFX_IMP_UNSUMMON);
int FlySpamFix;
if(GetLocalInt(OBJECT_SELF,"FlySpamFix")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(OBJECT_SELF,"FlySpamFix",TRUE);
DelayCommand(2.0,SetLocalInt(OBJECT_SELF,"FlySpamFix",FALSE));
ApplyEffectToObject(DURATION_TYPE_TEMPORARY,Dis,oPC);
ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPC);
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,App,oPC));
}
}
