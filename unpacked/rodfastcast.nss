//::///////////////////////////////////////////////
//::Rod of Fast Buffing Item Event Script
/*
    This is the event script for the rod of fast
    buffing. This rod allows casters to group
    all their buffing spells into a single action
*/
//:://////////////////////////////////////////////

#include "x2_inc_switches"

//showing spell names is a 2da file hit. When storing
//a lot of spells this can cause a significant delay
//When this value is false it will just show spell
//ID numbers.
const int knShowSpellName = TRUE;

//used to store the number of spells on the rod
const string ksNumSpells = "NumSpells";
//used as a base to store a spell ID to cast
const string ksCastSpellId = "CastSpells";
//stores the spell name when you store a spell.
const string ksCastSpellName = "SpellName";

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    object oPC;         //The caster
    object oItem;       //This item

    int nSpellId;       //Used to hold the ID of the current spell;
    int nNumOfSpells;   //Used to hold the current number of spells on the rod

    string strSpellName;//Used to hold the Spell Name

    int nResult = X2_EXECUTE_SCRIPT_CONTINUE;

    //this handles "use" or activation of item.
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        oItem = GetItemActivated();
        oPC = GetItemActivator();

        //Disable use in combat
        if(GetIsInCombat(oPC))
        {
            FloatingTextStringOnCreature("Can't use rod in combat", oPC, FALSE);
            return;
        }

        //get number of spells stored
        nNumOfSpells = GetLocalInt(oItem, ksNumSpells);
        SendMessageToPC(oPC, " Attempting to fast cast " + IntToString(nNumOfSpells) + " spells.");

        //iterate through array of spells and store casting action
        int n;
        for(n = 1; n <= nNumOfSpells; n++)
        {
            //get spell id stored at location n
            nSpellId = GetLocalInt(oItem, ksCastSpellId + IntToString(n));

            //Get the name of the spell stored at location n
            strSpellName = GetLocalString(oItem, ksCastSpellName + IntToString(n));

            SendMessageToPC(oPC, "Casting spell "
                            + strSpellName
                            + " at postion "
                            + IntToString(n)
                            + " on item");

            // GetHasSpell() returns 0 for domain spells (e.g. Cat's Grace on a Cleric)
            // even when memorized, so we skip that check and let the engine handle
            // missing slots gracefully.
            if(0 != nSpellId)
            {
                AssignCommand(oPC,
                ActionCastSpellAtObject(nSpellId
                                        , oPC
                                        , METAMAGIC_ANY
                                        , FALSE
                                        , 0
                                        , PROJECTILE_PATH_TYPE_DEFAULT
                                        , TRUE));
            }
        }
    } //This Event Handles storing the spells
    else if (nEvent ==  X2_ITEM_EVENT_SPELLCAST_AT)
    {
        oItem = GetSpellTargetObject();
        nSpellId = GetSpellId();
        oPC = OBJECT_SELF;
        nNumOfSpells = GetLocalInt(oItem, ksNumSpells) + 1;

        SetLocalInt(oItem, ksNumSpells , nNumOfSpells);
        SetLocalInt(oItem, ksCastSpellId + IntToString(nNumOfSpells), nSpellId);

        strSpellName = (knShowSpellName)
                        ? Get2DAString("spells", "Label", nSpellId)
                        : IntToString(nSpellId);

        SetLocalString(oItem, ksCastSpellName + IntToString(nNumOfSpells), strSpellName);

        SendMessageToPC(oPC, "Storing "
                          + strSpellName
                          + " at postion "
                          + IntToString(nNumOfSpells)
                          + " on item");

        nResult = X2_EXECUTE_SCRIPT_END;

    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

