//by Aldaron, 24042004


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





SetLocalInt (oPC, "PlayerInKOH", 0);


//--- first check if the player is the last player to exit.


object oKOHPlayers = GetFirstPC ();
int cptest;
int DontDestroyCTFDC;

while (GetIsObjectValid(oKOHPlayers))
{
cptest = GetLocalInt (oKOHPlayers, "PlayerInKOH");
if (cptest == 1)
 {
 DontDestroyCTFDC = 1;
 }
oKOHPlayers = GetNextPC();
}

if (DontDestroyCTFDC != 1)
{
//if yes reset scores

//ActionSpeakString ("KOH emptied", TALKVOLUME_SHOUT);//debug
object oCTFScoreKeeper = GetObjectByTag("KOHScoreBoard");
SetLocalInt(oCTFScoreKeeper, "BlueScore", 0);
SetLocalInt(oCTFScoreKeeper, "RedScore", 0);
SetLocalInt(oCTFScoreKeeper, "KOHEmpty", 1);
SetLocalInt(oCTFScoreKeeper, "HillHolder", 0);
}

//---tested thoroughly! (it worx!)



string sNewPlayer = GetName(oPC);
string sPCEnterCTF = sNewPlayer + " has left the KoH arena.";
SendKOHMessage (sPCEnterCTF);

 SendMessageToPC (oPC, "You have now left the King of the Hill arena.");
 //teleoport player to the hall
 object oWP2GO = GetWaypointByTag("starting");
 location lLOC2GO = GetLocation(oWP2GO);
 AssignCommand(oPC, JumpToLocation(lLOC2GO));







}






