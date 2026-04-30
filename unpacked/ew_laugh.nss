/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
AssignCommand(oPC, ClearAllActions(TRUE));
AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,9999.0));
}

