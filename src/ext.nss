// DM Djinn's no leave script
// This script stops players leaving an area if there are still monsters
// Laive int it.  Also a DM can summon a player aslong as he sets
// The locat int to TRUE

void main()
{
object oPC = GetExitingObject();
if (GetLocalInt(oPC,"Dead")==TRUE)
    {
    SetLocalInt(oPC,"Dead",FALSE);
    return;
    }
if (GetLocalInt(oPC,"DMCALL")==TRUE)
    {
    SetLocalInt(oPC,"DMCALL",FALSE);
    return;
    }
if (GetIsDM(oPC)==TRUE || GetLocalInt(GetModule(),"J"+GetPCPublicCDKey(oPC))==TRUE)
    {
    return;
    }

object oArea=GetLocalObject(oPC,"Area");
location lPC=GetLocalLocation(oArea,"location");
int nMon = GetLocalInt(oArea,"Numbspawns");

if (nMon >0 )
{
// Put this counting check in here to make sure we dont have problems
object oMon = GetFirstObjectInArea(oArea);
int iMon=0;
while (oMon !=OBJECT_INVALID)
{
if (GetObjectType(oMon)==OBJECT_TYPE_CREATURE && GetIsPC(oMon) !=TRUE && GetIsDM(oMon) !=TRUE && GetIsEnemy(oMon,oPC)==TRUE)
{
iMon +=1;
}
oMon = GetNextObjectInArea(oArea);
}
nMon = iMon;
SetLocalInt(oArea,"Numbspawns",iMon);
}
if (nMon >0)
         {
         SendMessageToPC(oPC,"All Spawns are not dead in this area You cannot leave");
         SendMessageToPC(oPC,"There are "+IntToString(nMon)+" Creatures left");
         DelayCommand(1.0,AssignCommand(oPC,JumpToLocation(lPC)));
         return;
         }
if (nMon == 0)
    {
    DeleteLocalInt(oArea,"Numbspawns");
    DeleteLocalLocation(oArea,"location");
    DeleteLocalInt(oArea,"jailed");
    }
}
