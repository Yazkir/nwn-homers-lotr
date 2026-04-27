// By Djinn
// This script sets up the anti running script
// It aslo adds a DM script for listing monsters and players in area

void main()
{
object oPC=GetEnteringObject();
object oArea=GetArea(oPC);

DeleteLocalInt(oArea,"jailed");

if (GetIsDM(oPC)==TRUE)
    {
    int nMon = GetLocalInt(oArea,"Numbspawns");
// Put this counting check in here to make sure we dont have problems
    object oMon = GetFirstObjectInArea(oArea);
    int iMon=0;
    while (oMon !=OBJECT_INVALID)
           {
           if (GetObjectType(oMon) == OBJECT_TYPE_CREATURE && GetIsPC(oMon) !=TRUE && GetIsDM(oMon) !=TRUE)
              {
              iMon +=1;
              }
           if (GetIsPC(oMon)==TRUE)
              {
              SendMessageToPC(oPC,GetName(oMon));
              }
           oMon = GetNextObjectInArea(oArea);
           }
    nMon = iMon;
    SetLocalInt(oArea,"Numbspawns",iMon);
    if (iMon >0)
        {
        SendMessageToPC(oPC,"There are "+IntToString(iMon)+" Spawned Monsters");
        }
             }
SetLocalInt(oPC,"DMCALL",FALSE);
SetLocalInt(oPC,"Dead",FALSE);
SetLocalLocation(oPC,"location",GetLocation(OBJECT_SELF));
SetLocalObject(oPC,"Area",GetArea(oPC));
}
