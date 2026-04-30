void main()
{
object oPC = GetExitingObject();

object oBox;
int iCounter = 1;
while(iCounter <= 5)
   {
   if(GetItemPossessedBy(oPC, "az_strongbox_" + GetPCPublicCDKey(oPC) + "_" + IntToString(iCounter)) != OBJECT_INVALID)
      {
      oBox = GetObjectByTag("az_strongbox_" + GetPCPublicCDKey(oPC) + "_" + IntToString(iCounter));
      StoreCampaignObject("bankdb", "bank_box_" + IntToString(iCounter), oBox, oPC);
      DestroyObject(oBox);
      }
   iCounter = iCounter + 1;
   }
ExportSingleCharacter(oPC);
return;
}




