//OnDamaged, makes any wpn other than Narsil worthless
void speak()
{
 switch (d100())
   {
       case 1:
         ActionSpeakString("Fool, none but the king of Gondor may command me!");
             break;
       case 20:
         ActionSpeakString("Your mortal weapons cannot hurt me!");
             break;
       case 50:
         ActionSpeakString("The way is shut. Now you must die");
             break;
   }
}

void main()
{
object oPC = GetLastDamager();

if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) != "narsil")
   {
   speak();
   int iHeal = GetTotalDamageDealt();
   ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(iHeal),OBJECT_SELF);
   }
}
