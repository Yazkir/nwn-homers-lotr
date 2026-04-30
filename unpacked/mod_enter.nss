                        #include "nw_i0_tool"
void main()
{
int     STARTING_GOLD   = 9000;
int     STARTING_XP     = 1000;
    object oPlayer = GetEnteringObject();
    object oPC = GetEnteringObject();

     //   Start at lvl 7 with 100k gp

if (!GetIsPC(oPC)) return;

int DoOnce = GetLocalInt(oPC, GetTag(OBJECT_SELF));

if (DoOnce==TRUE) return;

SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);

AddJournalQuestEntry("rules", 1, oPC, FALSE, FALSE);
AddJournalQuestEntry("gguild", 1, oPC, FALSE, FALSE);
AddJournalQuestEntry("website", 1, oPC, FALSE, FALSE);
if(!HasItem(oPlayer, "DyeKit"))
{
CreateItemOnObject("mil_dyekit001", oPlayer, 1);
}
{
  if (GetPCPlayerName(oPC) == "PlAyErS AcCoUnT NaMe") //Note: Remove the ")" in the end of this line if you would like to autoboot multiple users.
 //|| GetPCPlayerName(oPC) == "PlAyErS AcCoUnT NaMe") //Note: uncomment this line if you want to autoboot multiple users.
 {
  BootPC(oPC);
 }
}
if(!HasItem(oPlayer, "EmoteWand99"))
{
CreateItemOnObject("Emotewand99", oPlayer, 1);
}
if(!HasItem(oPlayer, "recall"))
{
CreateItemOnObject("recall", oPlayer, 1);
}
if(!HasItem(oPlayer, "PCQuill"))
{
CreateItemOnObject("pcquill", oPlayer, 1);
}
if (GetHitDice(oPlayer) <= 1)
   {

   }

    if(GetIsPC(oPlayer) && !(GetXP(oPlayer)) && !(GetIsDM(oPlayer)))
    {

        GiveGoldToCreature(oPlayer, STARTING_GOLD - GetGold(oPlayer));
        GiveXPToCreature(oPlayer, STARTING_XP - GetXP(oPlayer));


        object oPC = GetEnteringObject();

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


     }
