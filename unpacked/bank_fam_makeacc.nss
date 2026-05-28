void main()
{
object oPC = GetPCSpeaker();
string sCDKey = GetPCPublicCDKey(oPC);
SetCampaignInt("bankdb", "fam_account_" + sCDKey, 1);
object oVault = GetObjectByTag("pl_vaultstorage");
object oBox = GetItemPossessedBy(oVault, "az_familybox");
string sBoxTag = "az_familybox_" + sCDKey + "_1";
CopyObject(oBox, GetLocation(oVault), oVault, sBoxTag);
oBox = GetItemPossessedBy(oVault, sBoxTag);
StoreCampaignObject("bankdb", "fam_box_" + sCDKey + "_1", oBox);
DestroyObject(oBox);
TakeGoldFromCreature(11500, oPC);
}
