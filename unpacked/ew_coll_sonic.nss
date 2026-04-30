/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
#include"inc_emotewand"
void main()
{
object oPC = GetPCSpeaker();
int WeapCollor;
if(GetLocalInt(oPC,"WeapCollor")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"WeapCollor",TRUE);
DelayCommand(2.0,SetLocalInt(oPC,"WeapCollor",FALSE));
AddItemPropertyVisualEffect(oPC,INVENTORY_SLOT_RIGHTHAND,ITEM_VISUAL_SONIC);
}
}
