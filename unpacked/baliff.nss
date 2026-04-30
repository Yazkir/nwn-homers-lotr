int StartingConditional()
{
object oPC=GetPCSpeaker();

string sTag=GetTag(OBJECT_SELF);

return (GetLocalInt(oPC, sTag)==0);

}
