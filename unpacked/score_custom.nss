//////////////////////////////////
//Custom Player Score
//Scripted By:Butcha
/////////////////////////////////
string Score()
{
object oPlayer = GetFirstPC();
int iDied;
int iDied2;
int iKilled;
int iKilled2;
string SpeakText = "<cç>Kills<c‚‚‚>/ <cññõ>Deaths";
while (GetIsPC(oPlayer) == TRUE)
{
iDied = GetLocalInt(oPlayer,"iDied");
iDied2 =  GetCampaignInt("PointScore","iDied2",oPlayer);
iKilled = GetLocalInt(oPlayer,"iKilled");
iKilled2 =  GetCampaignInt("PointScore","iKilled2",oPlayer);
SpeakText += "\n";
SpeakText += "<cÙÒ>-----------------------------";
SpeakText += "\n";
SpeakText += "<cî>Name: <cîî>"+GetName(oPlayer);
SpeakText += "\n";
SpeakText += "<cî>Score: <cç>"+IntToString(iKilled)+"<c‚‚‚>/<cññõ>"+IntToString(iDied);
SpeakText += "\n";
SpeakText += "<cî>Score Totalt: <cç>"+IntToString(iKilled2)+"<c‚‚‚>/<cññõ>"+IntToString(iDied2);
SpeakText += "\n";
SpeakText += "<cÙÒ>-----------------------------";
SpeakText += "\n";
oPlayer = GetNextPC();
}
return SpeakText;
}
void main()
{
object oPC = GetPCSpeaker();
string sPlayerlist = Score();
SetCustomToken(1999, sPlayerlist);
}
