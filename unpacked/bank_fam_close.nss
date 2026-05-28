void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
object oBox;
int iCounter = 1;
while(iCounter <= 5)
   {
   string sBoxTag = "az_familybox_" + sCDKey + "_" + IntToString(iCounter);
   if(GetItemPossessedBy(oPC, sBoxTag) != OBJECT_INVALID)
      {
      oBox = GetObjectByTag(sBoxTag);
      StoreCampaignObject("bankdb", "fam_box_" + sCDKey + "_" + IntToString(iCounter), oBox);
      DestroyObject(oBox);
      }
   iCounter = iCounter + 1;
   }
ExportSingleCharacter(oPC);
}
