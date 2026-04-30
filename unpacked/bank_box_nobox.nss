int StartingConditional()
{
int iFlag;
object oPC = GetPCSpeaker();

if(GetItemPossessedBy(oPC, "az_strongbox_" + GetPCPublicCDKey(oPC) + "_" + IntToString(GetCampaignInt("bankdb", "bank_account", oPC))) == OBJECT_INVALID)
   {iFlag = 1;}
   else
   {iFlag = 0;}
return iFlag;
}
