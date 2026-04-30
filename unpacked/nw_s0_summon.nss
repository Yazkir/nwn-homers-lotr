//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: NW_S0_Summon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Monster Series of spells
    1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

effect SetSummonEffect(int nSpellID);

void main()
{
    //Declare major variables
    int nSpellID = GetSpellId();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    nDuration = 24;
    if(nDuration == 1)
    {
        nDuration = 2;
    }
    effect eSummon = SetSummonEffect(nSpellID);

    //Make metamagic check for extend
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}


effect SetSummonEffect(int nSpellID)
{
    int nFNF_Effect;
    int nRoll = d3();
    string sSummon;
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER)) //WITH THE ANIMAL DOMAIN
    {
        if(nSpellID == SPELL_SUMMON_CREATURE_I)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_BOARDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_II)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_WOLFDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_III)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_SPIDDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IV)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_beardire";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_V)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_diretiger";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VI)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRHUGE";
                break;

                case 2:
                    sSummon = "NW_S_WATERHUGE";
                break;

                case 3:
                    sSummon = "NW_S_FIREHUGE";
                break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VII)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRGREAT";
                break;

                case 2:
                    sSummon = "NW_S_WATERGREAT";
                break;

                case 3:
                    sSummon = "NW_S_FIREGREAT";
                break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VIII)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRELDER";
                break;

                case 2:
                    sSummon = "NW_S_WATERELDER";
                break;

                case 3:
                    sSummon = "NW_S_FIREELDER";
                break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IX)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRELDER";
                break;

                case 2:
                    sSummon = "NW_S_WATERELDER";
                break;

                case 3:
                    sSummon = "NW_S_FIREELDER";
                break;
            }
        }
    }
    else  //WITOUT THE ANIMAL DOMAIN
    {
        if(nSpellID == SPELL_SUMMON_CREATURE_I)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_badgerdire";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_II)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_BOARDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_III)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_WOLFDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IV)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_SPIDDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_V)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_beardire";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VI)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_diretiger";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VII)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRHUGE";
                break;

                case 2:
                    sSummon = "NW_S_WATERHUGE";
                break;

                case 3:
                    sSummon = "NW_S_FIREHUGE";
                break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VIII)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRGREAT";
                break;

                case 2:
                    sSummon = "NW_S_WATERGREAT";
                break;

                case 3:
                    sSummon = "NW_S_FIREGREAT";
                break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IX)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll)
            {
                case 1:
                    sSummon = "NW_S_AIRELDER";
                break;

                case 2:
                    sSummon = "NW_S_WATERELDER";
                break;

                case 3:
                    sSummon = "NW_S_FIREELDER";
                break;
            }
        }
    }

    // Start of customized summon spells
    // Check for Creature Summoning IX
    if (nSpellID == SPELL_SUMMON_CREATURE_IX)
    {

    // Get object for usage
    object oAmulet = GetItemInSlot(INVENTORY_SLOT_NECK);
    string sAmuletTag = GetTag(oAmulet);
    // Rolling dice for determen which creature of the amulet is summoned
    int nRandomCreature = Random(3)+1;
    // begin checkink for the specified amulet

    if (sAmuletTag == "wwi_amuletalch"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_dreadstaff";
        break;
        case 2:
            sSummon = "wwp_sanguineswor";
        break;
        case 3:
            sSummon = "wwp_floatingbow";
        break;
        }
    }
    if (sAmuletTag == "wwi_amuletshadow"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_shadowdragon";
        break;
        case 2:
            sSummon = "wwp_shadowweaver";
        break;
        case 3:
            sSummon = "wwp_spellweaver";
        break;
        }
    }
    if (sAmuletTag == "wwi_amuletplanar"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_balrog";
        break;
        case 2:
            sSummon = "wwp_darkmage";
        break;
        case 3:
            sSummon = "wwp_animatedarmo";
        break;
        }
    }
    if (sAmuletTag == "wwi_amuletfire"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_firewarrior";
        break;
        case 2:
            sSummon = "wwp_firecat";
        break;
        case 3:
            sSummon = "wwp_lightningwol";
        break;
        }
    }
    if (sAmuletTag == "wwi_amuletdead"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_mummypharaoh";
        break;
        case 2:
            sSummon = "wwp_undeadgiant";
        break;
        case 3:
            sSummon = "wwp_bonewarrior";
        break;
        }
    }
    if (sAmuletTag == "wwi_amuletvenom"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_succubusquee";
        break;
        case 2:
            sSummon = "wwp_greaterarach";
        break;
        case 3:
            sSummon = "wwp_flamespider";
        break;
        }
    }
    if (sAmuletTag == "wwi_amuletwild"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_trollseer";
        break;
        case 2:
            sSummon = "wwp_umberhulksha";
        break;
        case 3:
            sSummon = "wwp_koboldren";
        break;
        }
    }
    if (sAmuletTag == "wwi_amuletmagic"){
        switch (nRandomCreature) {
        case 1:
            sSummon = "wwp_wizardslayer";
        break;
        case 2:
            sSummon = "wwp_fairy";
        break;
        case 3:
            sSummon = "wwp_rashakafemal";
        break;
        }
    }



    }
    // End of Customized summoning

    //effect eVis = EffectVisualEffect(nFNF_Effect);
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect);
    return eSummonedMonster;
}

