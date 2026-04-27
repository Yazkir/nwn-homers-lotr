//by Aldaron, 29032004 and 13042004

void SendCTFMessage (string sMessage)
{
object oPC = GetFirstPC();
while ((GetIsObjectValid (oPC)) == TRUE)
{
int PC_gets_CTF_message = GetLocalInt (oPC, "PlayerInCTF");
 if (PC_gets_CTF_message == 1)
 {
 SendMessageToPC (oPC, sMessage);
 }
oPC = GetNextPC();
}
}



void main()
{
object oPC = GetLastSpeaker();


//--- first check if the player is the first player to enter.
//If yes, create the CTF death checker object (it has heartbeat so do this 2 reduce lag)

object oCTFPlayers = GetFirstPC ();
int cptest;
int DontMakeCTFDC;

while (GetIsObjectValid(oCTFPlayers))
{
cptest = GetLocalInt (oCTFPlayers, "PlayerInCTF");
if (cptest == 1)
 {
 DontMakeCTFDC = 1;
 }
oCTFPlayers = GetNextPC();
}

if (DontMakeCTFDC != 1)
{
//ActionSpeakString ("CTFDC created!", TALKVOLUME_SHOUT);   //debug
location lCTFDC = GetLocation(GetObjectByTag("ctfdcwp"));
CreateObject (OBJECT_TYPE_PLACEABLE, "ctfdc", lCTFDC);
}

//---tested thoroughly! (it worx!)



string sNewPlayer = GetName(oPC);
string sPCEnterCTF = sNewPlayer + " has entered the CTF arena.";
SendCTFMessage (sPCEnterCTF);

int oPCali = GetAlignmentGoodEvil(oPC);
SetLocalInt (oPC, "PlayerInCTF", 1);
if (oPCali==ALIGNMENT_GOOD)
 {
 SendMessageToPC (oPC, "You are now participating in Capture The Flag. You are on the Blue team.");
 //teleoport player to blue flag
 object oWP2GO = GetWaypointByTag("BlueTeamRespawn");
 location lLOC2GO = GetLocation(oWP2GO);
 AssignCommand(oPC, JumpToLocation(lLOC2GO));
 }
if (oPCali==ALIGNMENT_EVIL)
 {
 SendMessageToPC (oPC, "You are now participating in Capture The Flag. You are on the Red team.");
 object oWP2GO = GetWaypointByTag("RedTeamRespawn");
 location lLOC2GO = GetLocation(oWP2GO);
 AssignCommand(oPC, JumpToLocation(lLOC2GO));
 }

}






