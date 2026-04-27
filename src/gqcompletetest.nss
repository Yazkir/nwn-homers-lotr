//aldaron 13042004

int StartingConditional()
{
    int iResult;
//RobeoftheGwathdorLord
//  iResult = <<PLACE THE CONDITIONAL HERE>>;
//    return iResult;

object oPC = GetPCSpeaker();

object ItemCheck = GetFirstItemInInventory(oPC);
string ItemTag;

while (GetIsObjectValid(ItemCheck))
{
ItemTag = GetTag(ItemCheck);
 if (ItemTag == "gwathpipe")
 {
 DestroyObject (ItemCheck);
 return TRUE;
 }
ItemCheck = GetNextItemInInventory(oPC);
}

return FALSE;
}
