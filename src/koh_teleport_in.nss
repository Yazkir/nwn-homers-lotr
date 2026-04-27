//by Aldaron, 24.04.2004


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
object oPC = GetLastSpeaker();






string sNewPlayer = GetName(oPC);
string sPCEnterKOH = sNewPlayer + " has entered the KoH arena.";
SendKOHMessage (sPCEnterKOH);

int oPCali = GetAlignmentGoodEvil(oPC);
SetLocalInt (oPC, "PlayerInKOH", 1);

object oCTFScoreKeeper = GetObjectByTag("KOHScoreBoard");
SetLocalInt(oCTFScoreKeeper, "KOHEmpty", 0);

if (oPCali==ALIGNMENT_GOOD)
 {
 SendMessageToPC (oPC, "You are now participating in King of the Hill. You are on the Blue team.");
 //teleoport player to blue start
 object oWP2GO = GetWaypointByTag("kohblue");
 location lLOC2GO = GetLocation(oWP2GO);
 AssignCommand(oPC, JumpToLocation(lLOC2GO));
 }
if (oPCali==ALIGNMENT_EVIL)
 {
 SendMessageToPC (oPC, "You are now participating in King of the Hill. You are on the Red team.");
 object oWP2GO = GetWaypointByTag("kohred");
 location lLOC2GO = GetLocation(oWP2GO);
 AssignCommand(oPC, JumpToLocation(lLOC2GO));
 }

}






