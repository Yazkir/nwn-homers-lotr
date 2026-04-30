int StartingConditional()
{
int iFlag;
object oPC = GetPCSpeaker();

if(GetItemPossessedBy(oPC, "az_strongbox_" + GetPCPublicCDKey(oPC) + "_" + IntToString(GetCampaignInt("bankdb", "bank_account", oPC))) != OBJECT_INVALID)
   {iFlag = 1;}
   else
   {iFlag = 0;}

    object oDupe = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oDupe ))
    {
         if(GetTag(oDupe) == "ChosenFist" ||GetTag(oDupe) ==  "ChickyChickyGauntlet" ||GetTag(oDupe) ==  "EpicGauntletofGollum" ||GetTag(oDupe) ==  "Glamdring" ||GetTag(oDupe) ==  "Glamdring3" ||GetTag(oDupe) ==  "DMsHelper")
         {
                DestroyObject(oDupe);
                WriteTimestampedLogEntry("ILLEGAL ITEM (" + GetTag(oDupe) + " - " + GetPCPlayerName(oPC) + " [" + GetPCPublicCDKey(oPC) + "]");
         }
         oDupe = GetNextItemInInventory(oPC);
    }

    // Glamdring
    // Glamdring3
    // ChosenFist
    // EpicGauntletofGollum
    // DMsHelper
    // ChickyChickyGauntlet




return iFlag;
}
