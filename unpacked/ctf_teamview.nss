//view names of ppl participating in ctf and what teams theyre on
//aldaron 14042004

void main()
{

object oPC = GetLastUsedBy();
object oCPC;
int part;
int ali;
int hf;
string sName;
string Str2Speak;
int blue;
int red;

oCPC = GetFirstPC();

while (GetIsObjectValid(oCPC))
{
 part = GetLocalInt (oCPC, "PlayerInCTF");
 if (part == 1)
 {
  ali = GetAlignmentGoodEvil(oCPC);
  if (ali == ALIGNMENT_GOOD)
  {
   sName = GetName (oCPC);
   Str2Speak = "(BLUE) :" + sName;
   SendMessageToPC (oPC, Str2Speak);
//   ActionSpeakString (Str2Speak, TALKVOLUME_TALK);
   blue++;
  }
 }
 oCPC = GetNextPC();
}


oCPC = GetFirstPC();
while (GetIsObjectValid(oCPC))
{
 part = GetLocalInt (oCPC, "PlayerInCTF");
 if (part == 1)
 {
  ali = GetAlignmentGoodEvil(oCPC);
  if (ali == ALIGNMENT_EVIL)
  {
   sName = GetName (oCPC);
   Str2Speak = "(RED) :" + sName;
   SendMessageToPC (oPC, Str2Speak);
//   ActionSpeakString (Str2Speak, TALKVOLUME_TALK);
   red++;
  }
 }
 oCPC = GetNextPC();
}

string bluet = IntToString(blue);
string redt = IntToString(red);
string final = "Blue team: " + bluet + " Red team: " + redt;
SendMessageToPC (oPC, final);


oCPC = GetFirstPC();
while (GetIsObjectValid(oCPC))
{
 part = GetLocalInt (oCPC, "PlayerInCTF");
 if (part == 1)
 {
  hf = GetLocalInt(oCPC, "HasFlag");
  if (hf == 1)
  {
   ali = GetAlignmentGoodEvil(oCPC);
   if (ali == ALIGNMENT_EVIL)
   {
    sName = GetName (oCPC);
    Str2Speak = sName + " has the blue flag.";
    SendMessageToPC (oPC, Str2Speak);
   }
   if (ali == ALIGNMENT_GOOD)
   {
    sName = GetName (oCPC);
    Str2Speak = sName + " has the red flag.";
    SendMessageToPC (oPC, Str2Speak);
   }
  }
 }
 oCPC = GetNextPC();
}

}
