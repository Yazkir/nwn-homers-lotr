/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
#include"inc_emotewand"
void main()
{
object oPC = GetPCSpeaker();
int Dancefix;
if(GetLocalInt(oPC,"Dancefix")== TRUE)
{
FloatingTextStringOnCreature("Spam Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"Dancefix",TRUE);
DelayCommand(14.0,SetLocalInt(oPC,"Dancefix",FALSE));
AssignCommand(oPC,ClearAllActions(TRUE));
Animation_Dance(oPC);
}
}
