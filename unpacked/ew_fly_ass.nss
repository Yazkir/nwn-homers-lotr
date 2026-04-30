/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
effect fire = EffectVisualEffect(VFX_FNF_FIREBALL);
effect Flyup = EffectDisappear();
effect Flydown = EffectAppear();
int FlyOnAssFix;
if(GetLocalInt(oPC,"FlyOnAssFix")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"FlyOnAssFix",TRUE);
DelayCommand(14.0,SetLocalInt(oPC,"FlyOnAssFix",FALSE));
AssignCommand(oPC,ClearAllActions(TRUE));
ApplyEffectToObject(DURATION_TYPE_INSTANT,Flyup,oPC);
ApplyEffectToObject(DURATION_TYPE_INSTANT,fire,oPC);
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,Flydown,oPC));
DelayCommand(2.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK)));
DelayCommand(4.5,AssignCommand(oPC,SpeakString("Damn...i never can landing right!",TALKVOLUME_TALK)));
}
}
