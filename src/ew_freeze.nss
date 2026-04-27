/*
Emote-Wand V1000 UpDate!
Scripted By:Butch
*/
void remvoeAllEffects(object oPC)
{
effect Firstnext = GetFirstEffect(oPC);
while(GetIsEffectValid(Firstnext))
{
RemoveEffect(oPC,Firstnext);
Firstnext = GetNextEffect(oPC);
}
}
void main()
{
object oPC = GetPCSpeaker();
effect Freeze = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
if(GetLocalInt(oPC,"Freeze")== 0)
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,Freeze,oPC);
SetLocalInt(oPC,"Freeze",1);
return;
}
if(GetLocalInt(oPC,"Freeze")== 1)
{
remvoeAllEffects(oPC);
SetLocalInt(oPC,"Freeze",0);
}
}
