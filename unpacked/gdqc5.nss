void main()
{
//make a roll
int Chooser;
object oPC = GetPCSpeaker();
Chooser = d3(1);

if (Chooser == 1)
 {
 SetLocalInt (oPC, "gdreward", 1);
 }
if (Chooser == 2)
 {
 SetLocalInt (oPC, "gdreward", 2);
 }
if (Chooser == 3)
 {
 SetLocalInt (oPC, "gdreward", 3);
 }


object CI;
string SCI;

CI = GetFirstItemInInventory(oPC);
while (GetIsObjectValid(CI))
{
SCI = GetTag(CI);
 if (SCI == "StolenRing")
 {
 DestroyObject(CI);
 }
CI = GetNextItemInInventory(oPC);
}


}
