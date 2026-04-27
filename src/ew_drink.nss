/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC = GetPCSpeaker();
effect Vis = EffectVisualEffect(VFX_IMP_STUN);
AssignCommand(oPC, ClearAllActions(TRUE));
AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
DelayCommand(2.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,10.0,5.0)));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPC));
}

