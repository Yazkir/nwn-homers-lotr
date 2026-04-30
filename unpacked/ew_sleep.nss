/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
effect Vis = EffectVisualEffect(VFX_IMP_SLEEP);
AssignCommand(oPC, ClearAllActions(TRUE));
AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,9999.0));
ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPC);
}
