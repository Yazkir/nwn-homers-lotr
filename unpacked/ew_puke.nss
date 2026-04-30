/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
effect Puke1 = EffectVisualEffect(VFX_COM_CHUNK_GREEN_MEDIUM);
effect Puke2 = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_MEDIUM);
int PukeFix;
if(GetLocalInt(oPC,"PukeFix")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"PukeFix",TRUE);
DelayCommand(3.0,SetLocalInt(oPC,"PukeFix",FALSE));
AssignCommand(oPC, ClearAllActions(TRUE));
AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE));
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,Puke1,oPC));
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,Puke2,oPC));
DelayCommand(1.0,AssignCommand(oPC,SpeakString("Bhhuaaarrggg",TALKVOLUME_TALK)));
}
}
