void main()
{
object oPC = GetPCSpeaker();
object oVault = GetNearestObjectByTag("pl_vaultstorage");

int iCounter = 1;
int iBoxNum = GetCampaignInt("bankdb", "bank_account", oPC);
while(iCounter <= iBoxNum)
   {
   RetrieveCampaignObject("bankdb", "bank_box_" + IntToString(iCounter), GetLocation(oVault), oPC, oPC);
   iCounter = iCounter + 1;
   }
return;
}
