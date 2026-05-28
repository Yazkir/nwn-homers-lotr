void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
int iBoxNum = GetCampaignInt("bankdb", "fam_account_" + sCDKey) + 1;
SetCampaignInt("bankdb", "fam_account_" + sCDKey, iBoxNum);
object oVault = GetObjectByTag("pl_vaultstorage");
object oBox = GetItemPossessedBy(oVault, "az_familybox");
string sBoxTag = "az_familybox_" + sCDKey + "_" + IntToString(iBoxNum);
CopyObject(oBox, GetLocation(oVault), oVault, sBoxTag);
oBox = GetItemPossessedBy(oVault, sBoxTag);
StoreCampaignObject("bankdb", "fam_box_" + sCDKey + "_" + IntToString(iBoxNum), oBox);
DestroyObject(oBox);
TakeGoldFromCreature(50000, oPC);
}
