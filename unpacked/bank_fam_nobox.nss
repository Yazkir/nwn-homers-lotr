int StartingConditional()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
int iCounter = 1;
while(iCounter <= 5)
   {
   if(GetItemPossessedBy(oPC, "az_familybox_" + sCDKey + "_" + IntToString(iCounter)) != OBJECT_INVALID)
      return 0;
   iCounter = iCounter + 1;
   }
return 1;
}
