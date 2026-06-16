//OnDamaged, makes any wpn other than Narsil worthless
void speak()
{
    // Taunt on roughly one in three qualifying hits, spoken immediately.
    // The original used switch(d100()) -- only rolls of exactly 1, 20 or 50
    // matched, so a bark fired on ~3% of hits -- and ActionSpeakString, which
    // queues a speak action that the combat action queue starves. Between the
    // two, the barks almost never appeared. Random(3) + SpeakString fixes both.
    if (Random(3) != 0) return;
    string s;
    switch (Random(3))
    {
        case 0: s = "Fool, none but the king of Gondor may command me!"; break;
        case 1: s = "Your mortal weapons cannot hurt me!"; break;
        case 2: s = "The way is shut. Now you must die"; break;
    }
    SpeakString(s);
}

void main()
{
object oPC = GetLastDamager();

if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) != "narsil")
   {
   // Paths of the Dead: the first time a character strikes the King with the
   // wrong weapon, plant the journal hint pointing them to the heir of Isildur
   // at Minas Tirith. Once per character (persists across reboots); no per-hit spam.
   if (GetIsPC(oPC) && GetCampaignInt("potd", "started", oPC) == 0)
      {
      SetCampaignInt("potd", "started", 1, oPC);
      AddJournalQuestEntry("paths_of_the_dead", 1, oPC, FALSE, FALSE);
      }
   speak();
   int iHeal = GetTotalDamageDealt();
   ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(iHeal),OBJECT_SELF);
   }
}
