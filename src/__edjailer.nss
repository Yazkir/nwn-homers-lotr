//BY:BUTCH
void TeleportJail(object oPC,string sWaypoint,int Vfx1,int Vfx2);
void TeleportJail(object oPC,string sWaypoint,int Vfx1,int Vfx2)
{
object oPlayer = GetFirstPC();
effect eVfx1 = EffectVisualEffect(Vfx1);
effect eVfx2 = EffectVisualEffect(Vfx2);
object oTeletarget = GetObjectByTag(sWaypoint);
while(GetIsObjectValid(oPlayer))
{
if((GetIsReactionTypeHostile(oPlayer,oPC)==TRUE)||
   (GetReputation(oPC,oPlayer)== 0)==TRUE)
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,eVfx1,oPlayer);
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVfx2,oPlayer));
DelayCommand(1.5,AssignCommand(oPlayer,ActionJumpToObject(oTeletarget)));
}
oPlayer = GetNextPC();
}
}
void main()
{
object oPC = GetPCSpeaker();
TeleportJail(oPC,"Jail",VFX_IMP_DEATH_WARD,VFX_DUR_DEATH_ARMOR);

}

