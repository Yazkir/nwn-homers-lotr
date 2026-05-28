void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
object oVault = GetNearestObjectByTag("pl_vaultstorage");
int iBoxNum = GetCampaignInt("bankdb", "fam_account_" + sCDKey);
int iCounter = 1;
while(iCounter <= iBoxNum)
   {
   RetrieveCampaignObject("bankdb", "fam_box_" + sCDKey + "_" + IntToString(iCounter), GetLocation(oVault), oPC);
   iCounter = iCounter + 1;
   }
}
