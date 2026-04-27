/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
effect Vis = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
int FakeDeath;
if(GetLocalInt(oPC,"FakeDeath")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"FakeDeath",TRUE);
DelayCommand(2.0,SetLocalInt(oPC,"FakeDeath",FALSE));
AssignCommand(oPC, ClearAllActions(TRUE));
AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,9999.0));
ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPC);
PlayVoiceChat(VOICE_CHAT_DEATH,oPC);
}
}
