/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void main()
{
object oPC  = GetPCSpeaker();
effect Vis1 = EffectVisualEffect(VFX_DUR_DEATH_ARMOR);
effect vis2 = EffectVisualEffect(VFX_IMP_DEATH_WARD);
effect link = EffectLinkEffects(Vis1,vis2);
int Alignmentfix;
if(GetLocalInt(oPC,"Alignmentfix")== TRUE)
{
FloatingTextStringOnCreature("Spam lagg Fix",oPC);
return;
}
else
{
SetLocalInt(oPC,"Alignmentfix",TRUE);
DelayCommand(2.0,SetLocalInt(oPC,"Alignmentfix",FALSE));
AdjustAlignment(oPC,ALIGNMENT_LAWFUL,25);
ApplyEffectToObject(DURATION_TYPE_INSTANT,link,oPC);
}
}
