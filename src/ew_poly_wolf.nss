/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
#include"inc_emotewand"
void main()
{
object oPC = GetPCSpeaker();
int PolyFix;
if(GetLocalInt(oPC,"PolyFix")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"PolyFix",TRUE);
DelayCommand(4.0,SetLocalInt(oPC,"PolyFix",FALSE));
PolyMorph(oPC,POLYMORPH_TYPE_WOLF);
}
}

