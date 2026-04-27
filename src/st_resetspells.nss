/*
#*#*#*#*#*#*#**#* SPELL TRACKING SYSTEM *#*#*#*#*#*#*#*#*
Spell Tracking System by Archaegeo
December 2002
File: st_resetspells
Purpose: Restores a PC's spell tracking to none cast, called
         by st_on_rest on a successful rest.
#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
*/
void DecrementTalentIndex(int iIndex, object oPC);

string sID;
object oMd=GetModule();
void main()
{
    object oPC = OBJECT_SELF;
    sID=GetName(oPC)+GetPCPublicCDKey(oPC);
    int iIndex;

    for (iIndex = 1; iIndex < 1000; iIndex++)
    {
        DecrementTalentIndex(iIndex, oPC);
    }
}

void DecrementTalentIndex(int iIndex, object oPC)
{
    int iDecrementIndex;

    talent tSpell;
    talent tFeat;

/* create our talent */
    tSpell = TalentSpell(iIndex);
    tFeat = TalentFeat(iIndex);

/* check for all spells */
    if (GetIsTalentValid(tSpell))
    {
        if (GetHasSpell(GetIdFromTalent(tSpell), oPC))
        {
            int nSpl=GetIdFromTalent(tSpell);
            DeleteLocalInt(oMd,"SPTRK"+sID+IntToString(nSpl));
        }
    }

/* check for all feats*/
    if (GetIsTalentValid(tFeat))
    {
        if (GetHasFeat(GetIdFromTalent(tFeat), oPC))
        {
            int nFt=GetIdFromTalent(tFeat);
            DeleteLocalInt(oMd,"SPTRK"+sID+IntToString(nFt));
        }
    }
}
