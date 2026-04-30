/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
#include"inc_emotewand"
void main()
{
object oPC = GetPCSpeaker();
int Appearancefix;
if(GetLocalInt(oPC,"Appearancefix")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"Appearancefix",TRUE);
DelayCommand(2.0,SetLocalInt(oPC,"Appearancefix",FALSE));
Appearance(oPC,APPEARANCE_TYPE_HUMAN);
}
}
