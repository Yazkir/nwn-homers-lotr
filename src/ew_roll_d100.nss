/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
#include"inc_emotewand"
void main()
{
object oPC = GetPCSpeaker();
int iSpamFix;
if(GetLocalInt(oPC,"iSpamFix")== TRUE)
{
FloatingTextStringOnCreature("Spam Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"iSpamFix",TRUE);
DelayCommand(5.0,SetLocalInt(oPC,"iSpamFix",FALSE));
Roll_D100(oPC);
}
}
