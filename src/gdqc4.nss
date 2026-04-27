int StartingConditional()
{
//check if he has ring
object oPC = GetPCSpeaker();

object nCI;
string nSCI;

nCI = GetFirstItemInInventory(oPC);
while (GetIsObjectValid(nCI))
{
nSCI = GetTag(nCI);
 if (nSCI == "StolenRing")
 {
 return TRUE;
 }
nCI = GetNextItemInInventory(oPC);
}

return FALSE;

}
