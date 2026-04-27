/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
#include"inc_emotewand"
void main()
{
object oPC = GetPCSpeaker();
AssignCommand(oPC,ClearAllActions(TRUE));
Superfly(oPC);
Camera(oPC);
}
