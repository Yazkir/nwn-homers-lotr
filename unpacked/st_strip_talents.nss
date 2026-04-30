/*
#*#*#*#*#*#*#**#* SPELL TRACKING SYSTEM *#*#*#*#*#*#*#*#*
Spell Tracking System by Archaegeo
December 2002
File: st_strip_talents
Purpose: Strips an entering player of all spells and those
         feats supported that they have previously cast since
         last resting.  Called by st_on_enter.
#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
*/
void DecrementTalentIndex(int iIndex, object oPC);
void DecrementAllSpells(int iIndex, object oPC);

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
    if(GetLocalInt(oPC,"STRIPALL"))
    {
        DeleteLocalInt(oPC,"STRIPALL");
        for (iIndex=1; iIndex < 200; iIndex++)
        {
            DecrementAllSpells(iIndex, oPC);
        }
    }
}

void DecrementAllSpells(int iIndex, object oPC)
{
    talent tSpell;
    tSpell = TalentSpell(iIndex);
    if (GetIsTalentValid(tSpell))
    {
        int nSpl=GetIdFromTalent(tSpell);
        while(GetHasSpell(nSpl, oPC))
        {
            DecrementRemainingSpellUses(oPC, nSpl);
        }
    }
}

void DecrementTalentIndex(int iIndex, object oPC)
{
    int iDecrementIndex, nSpellToFeat;
    string sName;
    nSpellToFeat=0;

    talent tSpell;
    talent tFeat;

/* create our talent */
    tSpell = TalentSpell(iIndex);
    tFeat = TalentFeat(iIndex);

/* check for all spells */
    if (GetIsTalentValid(tSpell))
    {
        int nSpl=GetIdFromTalent(tSpell);
        int nCast=GetLocalInt(oMd,"SPTRK"+sID+IntToString(nSpl));
        if (nCast)
        {
            switch(nSpl)
            {
                case 313 : nSpellToFeat=FEAT_LAY_ON_HANDS; break;
                case 317 : nSpellToFeat=FEAT_ANIMAL_COMPANION; break;
                case 383 : nSpellToFeat=FEAT_DEATH_DOMAIN_POWER; break;
                case 308 : nSpellToFeat=FEAT_TURN_UNDEAD; break;
                case 318 : nSpellToFeat=FEAT_SUMMON_FAMILIAR; break;
                default : nSpellToFeat=0;
            }
            if(nSpellToFeat)
            {
                while(nCast)
                {
                    DecrementRemainingFeatUses(oPC, nSpellToFeat);
                    nCast--;
                }
            }
            else
            {
                while(nCast && GetHasSpell(nSpl, oPC))
                {
                    DecrementRemainingSpellUses(oPC, nSpl);
                    nCast--;
                }
            }
            if(nCast)
            {
                if(!GetLocalInt(oPC,"STRIPALL"))
                    SendMessageToPC(oPC,"Due to game mechanics, and your having cast "+
                    "a cure spell spontaneously, you need to be stripped of all spells."+
                    "You may regain them per resting as per normal.");
                SetLocalInt(oPC,"STRIPALL",1);
            }
        }
    }
}
