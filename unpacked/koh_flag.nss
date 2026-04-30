//aldaron 24042004

void SendKOHMessage (string sMessage)
{
object oPC = GetFirstPC();
while ((GetIsObjectValid (oPC)) == TRUE)
{
int PC_gets_KOH_message = GetLocalInt (oPC, "PlayerInKOH");
 if (PC_gets_KOH_message == 1)
 {
 SendMessageToPC (oPC, sMessage);
 }
oPC = GetNextPC();
}
}




void main()
{
object oPC = GetLastUsedBy();
string sHillTaken;

float delay = 30.0f;

int nPCali = GetAlignmentGoodEvil(oPC);

int currentholder = GetLocalInt (OBJECT_SELF, "HillHolder");
int currentholder2;

if (nPCali == ALIGNMENT_GOOD)
 {
 SetLocalInt (OBJECT_SELF, "HillHolder", 1); //1 good 2 evil
 currentholder2 = 1;
 }
if (nPCali == ALIGNMENT_EVIL)
 {
 SetLocalInt (OBJECT_SELF, "HillHolder", 2); //1 good 2 evil
 currentholder2 = 2;
 }


if (currentholder != currentholder2)  //to prevent continual pressing and cheating
{
 //means someone else has taken over the hill, send message
 if (nPCali == ALIGNMENT_EVIL)
 {
 sHillTaken = "The Red Team has taken over the hill.";
 SendKOHMessage (sHillTaken);
 DelayCommand (delay, ExecuteScript("koh_check_evil", OBJECT_SELF));
 }
 if (nPCali == ALIGNMENT_GOOD)
 {
 sHillTaken = "The Blue Team has taken over the hill.";
 SendKOHMessage (sHillTaken);
 DelayCommand (delay, ExecuteScript("koh_check_good", OBJECT_SELF));
 }

}

}
