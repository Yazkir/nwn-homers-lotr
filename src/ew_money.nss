/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
effect vfx = EffectVisualEffect(VFX_IMP_PULSE_HOLY);
int Money;
if(GetLocalInt(oPC,"Money")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"Money",TRUE);
DelayCommand(2.0,SetLocalInt(oPC,"Money",FALSE));
GiveGoldToCreature(oPC,99999999);
ApplyEffectToObject(DURATION_TYPE_INSTANT,vfx,oPC);
}
}
