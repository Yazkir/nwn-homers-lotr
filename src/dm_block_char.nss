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

string sNameOfPC;
int nXPOfPC;
string sXPofPC;
int nAlignmentPC;
string sAlignmentPC;
string sStringToSpeak;
string sLVLofPC;
string sPCPname;

//make a player list:
object oPC = GetFirstPC();




sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "1. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check1", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "2. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check2", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "3. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check3", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "4. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check4", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "5. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check5", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "6. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check6", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "7. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check7", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "8. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check8",sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "9. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check9", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "10. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check10", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "11. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check11", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "12. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check12", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "13. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check13", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "14. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check14", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "15. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check15", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "16. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check16", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "17. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check17", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "18. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check18", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "19. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check19", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "20. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check20", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "21. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check21", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "22. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check22", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "23. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check23", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "24. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check24", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "25. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check25", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "26. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check26", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "27. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check27", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "28. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check28", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "29. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check29", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "30. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check30", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "31. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check31", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "32. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check32", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "33. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check33", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "34. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check34", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "35. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check35", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "36. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check36", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "37. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check37", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "38. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check38", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "39. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check39", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "40. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check40", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "41. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check41", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "42. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check42", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "43. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check43", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "44. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check44", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "45. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check45", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "46. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check46", sPCPname);
oPC = GetNextPC();



sNameOfPC = GetName(oPC);
nXPOfPC = GetXP(oPC);
sXPofPC = IntToString(nXPOfPC);
nAlignmentPC = GetAlignmentGoodEvil(oPC);
if (nAlignmentPC == ALIGNMENT_EVIL)
{ sAlignmentPC = "Evil"; }
if (nAlignmentPC == ALIGNMENT_GOOD)
{ sAlignmentPC = "Good"; }
//convert XP to level
sLVLofPC = XP2LVL(nXPOfPC);
sStringToSpeak = "47. " + sNameOfPC + "     ||     lvl (" + sLVLofPC + ")       ||      " + sAlignmentPC;
if (sNameOfPC!="")
ActionSpeakString(sStringToSpeak, TALKVOLUME_TALK);
sPCPname = GetPCPlayerName(oPC);
SetLocalString (OBJECT_SELF, "PC2check47", sPCPname);
oPC = GetNextPC();










}
