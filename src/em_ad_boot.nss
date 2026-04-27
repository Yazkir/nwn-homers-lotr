void main()
{
object oPC = GetPCSpeaker();
object oPlayer = GetFirstPC();
while(GetIsObjectValid(oPlayer))
{
if((GetIsReactionTypeHostile(oPlayer,oPC)==TRUE)||
   (GetReputation(oPC,oPlayer)== 0)==TRUE)
{
BootPC(oPlayer);
}
if((GetIsReactionTypeHostile(oPlayer,oPC)==FALSE)&&(GetReputation(oPC,oPlayer)== 0)==FALSE)
{
FloatingTextStringOnCreature("Set ya target dislike first",oPC);
}
oPlayer = GetNextPC();
}
}
