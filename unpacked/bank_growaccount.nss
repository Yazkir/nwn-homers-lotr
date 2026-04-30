void main()
{
object oPC = GetPCSpeaker();
int iAccountNum = GetCampaignInt("bankdb", "bank_account", oPC);
SetCampaignInt("bankdb", "bank_account", iAccountNum + 1, oPC);
object oVault = GetObjectByTag("pl_vaultstorage");
object oBox = GetItemPossessedBy(oVault, "az_strongbox");
int iBoxNum = GetCampaignInt("bankdb", "bank_account", oPC);
CopyObject(oBox, GetLocation(oVault), oVault, "az_strongbox_" + GetPCPublicCDKey(oPC) + "_" + IntToString(iBoxNum));

oBox = GetItemPossessedBy(oVault, "az_strongbox_" + GetPCPublicCDKey(oPC) + "_" + IntToString(iBoxNum));
StoreCampaignObject("bankdb", "bank_box_" + IntToString(iBoxNum), oBox, oPC);
DestroyObject(oBox);

TakeGoldFromCreature(5000, oPC);
}
