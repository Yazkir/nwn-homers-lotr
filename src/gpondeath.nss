void main()
{
float CR = GetChallengeRating(OBJECT_SELF);
int iCR = FloatToInt(CR);
int iGP = (iCR * 8) + d20();
GiveGoldToCreature(GetLastKiller(), iGP);
ExecuteScript("pwfxp",OBJECT_SELF);
int iRace = GetRacialType(OBJECT_SELF);
if (iRace == RACIAL_TYPE_ANIMAL  || iRace == RACIAL_TYPE_BEAST || iRace == RACIAL_TYPE_DRAGON)
 {
 ExecuteScript("trade_death",OBJECT_SELF);
 }
}
