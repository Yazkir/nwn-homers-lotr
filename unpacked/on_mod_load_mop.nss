                                     #include "nw_i0_tool"

void main()
{
int     STARTING_GOLD   = 5000;
    object oPlayer = GetEnteringObject();



SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);

if (!HasItem(oPlayer, "DyeKit"))
{
CreateItemOnObject("mil_dyekit001", oPlayer, 1);
}
if ( !HasItem(oPlayer, "emotewand99"))
{
DestroyObject(oPlayer, 0.0);
}
if ( !HasItem(oPlayer, "recall"))
{
DestroyObject(oPlayer, 0.0 );
}
if ( !HasItem(oPlayer, "EmoteWand"))
{
DestroyObject(oPlayer, 0.0);
}
if(!HasItem(oPlayer, "StoneofDivineIntervention"))
{
DestroyObject(oPlayer, 0.0);
}
if (GetHitDice(oPlayer) <= 1)
    {
    RewardPartyXP(6001,oPlayer, FALSE);
    }
    if(GetIsPC(oPlayer) && !(GetXP(oPlayer)) && !(GetIsDM(oPlayer)))
    {
// Giving PC its starting gold.
        GiveGoldToCreature(oPlayer, STARTING_GOLD - GetGold(oPlayer));
// Set the Good Evil Factions
        object oPC = GetEnteringObject();
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        {
        AdjustReputation(oPC, GetObjectByTag("goodfaction"),100);
        AdjustReputation(oPC, GetObjectByTag("evilfaction"),-100);
        }
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        {
        AdjustReputation(oPC, GetObjectByTag("goodfaction"),-100);
        AdjustReputation(oPC, GetObjectByTag("evilfaction"),100);
        }
        }

     object oPC = GetEnteringObject();
     object oDeathAmulet;
     effect eDeath = EffectDeath( FALSE, FALSE );
     oDeathAmulet = GetFirstItemInInventory(oPC);

     while( GetIsObjectValid(oDeathAmulet))
     {
        if( GetTag( oDeathAmulet ) == "deathamulet" )
        {
           ApplyEffectToObject( DURATION_TYPE_INSTANT, eDeath, oPC);
           break;
        }
        oDeathAmulet = GetNextItemInInventory( oPC );
     }


  object oPC = GetEnteringObject();
  ZEP_PurifyAllItems(oPC,TRUE,TRUE);
}

