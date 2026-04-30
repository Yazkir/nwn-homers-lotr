string XP2LVL(int nPCXP)
{
string sFinalLVL;

if (nPCXP < 1000)
{
sFinalLVL = "1";
return sFinalLVL;
}
if (nPCXP < 3000)
{
sFinalLVL = "2";
return sFinalLVL;
}
if (nPCXP < 6000)
{
sFinalLVL = "3";
return sFinalLVL;
}
if (nPCXP < 10000)
{
sFinalLVL = "4";
return sFinalLVL;
}
if (nPCXP < 15000)
{
sFinalLVL = "5";
return sFinalLVL;
}
if (nPCXP < 21000)
{
sFinalLVL = "6";
return sFinalLVL;
}
if (nPCXP < 28000)
{
sFinalLVL = "7";
return sFinalLVL;
}
if (nPCXP < 36000)
{
sFinalLVL = "8";
return sFinalLVL;
}
if (nPCXP < 45000)
{
sFinalLVL = "9";
return sFinalLVL;
}
if (nPCXP < 55000)
{
sFinalLVL = "10";
return sFinalLVL;
}
if (nPCXP < 66000)
{
sFinalLVL = "11";
return sFinalLVL;
}
if (nPCXP < 78000)
{
sFinalLVL = "12";
return sFinalLVL;
}
if (nPCXP < 91000)
{
sFinalLVL = "13";
return sFinalLVL;
}
if (nPCXP < 105000)
{
sFinalLVL = "14";
return sFinalLVL;
}
if (nPCXP < 120000)
{
sFinalLVL = "15";
return sFinalLVL;
}
if (nPCXP < 136000)
{
sFinalLVL = "16";
return sFinalLVL;
}
if (nPCXP < 153000)
{
sFinalLVL = "17";
return sFinalLVL;
}
if (nPCXP < 171000)
{
sFinalLVL = "18";
return sFinalLVL;
}
if (nPCXP < 190000)
{
sFinalLVL = "19";
return sFinalLVL;
}
if (nPCXP < 210000)
{
sFinalLVL = "20";
return sFinalLVL;
}
if (nPCXP < 231000)
{
sFinalLVL = "21";
return sFinalLVL;
}
if (nPCXP < 253000)
{
sFinalLVL = "22";
return sFinalLVL;
}
if (nPCXP < 276000)
{
sFinalLVL = "23";
return sFinalLVL;
}
if (nPCXP < 300000)
{
sFinalLVL = "24";
return sFinalLVL;
}
if (nPCXP < 325000)
{
sFinalLVL = "25";
return sFinalLVL;
}
if (nPCXP < 351000)
{
sFinalLVL = "26";
return sFinalLVL;
}
if (nPCXP < 378000)
{
sFinalLVL = "27";
return sFinalLVL;
}
if (nPCXP < 406000)
{
sFinalLVL = "28";
return sFinalLVL;
}
if (nPCXP < 435000)
{
sFinalLVL = "29";
return sFinalLVL;
}
if (nPCXP < 465000)
{
sFinalLVL = "30";
return sFinalLVL;
}
if (nPCXP < 496000)
{
sFinalLVL = "31";
return sFinalLVL;
}
if (nPCXP < 528000)
{
sFinalLVL = "32";
return sFinalLVL;
}
if (nPCXP < 561000)
{
sFinalLVL = "33";
return sFinalLVL;
}
if (nPCXP < 595000)
{
sFinalLVL = "34";
return sFinalLVL;
}
if (nPCXP < 630000)
{
sFinalLVL = "35";
return sFinalLVL;
}
if (nPCXP < 666000)
{
sFinalLVL = "36";
return sFinalLVL;
}
if (nPCXP < 703000)
{
sFinalLVL = "37";
return sFinalLVL;
}
if (nPCXP < 741000)
{
sFinalLVL = "38";
return sFinalLVL;
}
if (nPCXP < 780000)
{
sFinalLVL = "39";
return sFinalLVL;
}

sFinalLVL = "40";
return sFinalLVL;
}





void main()
{

object oDMPCboard = GetObjectByTag("DMABboard");
object oPC2Check;
string PCName2Search = GetLocalString(oDMPCboard, "PC2check45");


int nXPOfFM;
string sNameOfFM;
int nAlignmentFM;
string sLVLOfFM;
string sAlignmentFM;
string sStringToSpeak;
string CurrentPCName;


//find the player
oPC2Check = GetFirstPC();
while ((GetIsObjectValid (oPC2Check)) == TRUE)
{
CurrentPCName = GetPCPlayerName(oPC2Check);
if (CurrentPCName == PCName2Search)
{
// make illegal and kick
object swp = GetObjectByTag("starting");
location lswp = GetLocation(swp);
AssignCommand (oPC2Check, ClearAllActions());
AssignCommand (oPC2Check, JumpToLocation(lswp));
SendMessageToPC (oPC2Check, "You will now be auto-booted by a DM.");
DelayCommand (7.0f, BootPC(oPC2Check));
}
oPC2Check = GetNextPC();
}



ActionSpeakString("Player set on auto-boot.", TALKVOLUME_TALK);


}
