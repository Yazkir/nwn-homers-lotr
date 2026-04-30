#include "color"

void main()
{
//Alerts which PC killed boss and where
object oBoss = OBJECT_SELF;
object oPC = GetLastHostileActor(oBoss);
object oArea = GetArea(oBoss);
string sBoss = GetName(oBoss);
string sPC = GetName(oPC);
string sArea = GetName(oArea);
object oPlayer = GetFirstPC();
if (GetIsDead(oBoss))
     while (oPlayer != OBJECT_INVALID)
        {
        string sMessage = (sBoss + " was killed by "+sPC+" in <cþ  > "+sArea + "</c>");
        SendMessageToPC(oPlayer, sMessage);
        oPlayer = GetNextPC();
        }

string tag = GetTag(OBJECT_SELF);

if (tag == "ADwarfAjudicator" || tag == "DunlandWarrior" || tag == "RivendellArcaneArcher" || tag == "RivendellWarrior")
{return;}

if(GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL){return;}

object oMod = GetModule();
string name = GetName(OBJECT_SELF); // or whatever to get the name of the dead NPC
if(GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
{
string currentList = GetLocalString( oMod, "GoodNPCDeathList");
  if( currentList != "") currentList += "; ";
  currentList += name;
  SetLocalString( oMod, "GoodNPCDeathList", currentList);
}
else
{

string currentList = GetLocalString( oMod, "EvilNPCDeathList");
  if( currentList != "") currentList += "; ";
  currentList += name;
  SetLocalString( oMod, "EvilNPCDeathList", currentList);

SpeakString("Helm's Deep is under attack, rally Free People of Middle Earth to Helm's Deep!", TALKVOLUME_SHOUT);

}



}
