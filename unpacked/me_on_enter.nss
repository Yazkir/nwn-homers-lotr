#include "nw_i0_tool"

void main()
{
int     STARTING_GOLD   = 5000;
    object oPlayer = GetEnteringObject();


if ( !HasItem(oPlayer, "recall"))
{
DestroyObject(oPlayer, 0.0);
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
    RewardPartyXP(1000,oPlayer, FALSE);
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

}
