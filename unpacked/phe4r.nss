void main()
{
object oPC = GetEnteringObject();
if (!GetIsPC(oPC)) return;
int DoOnce = GetLocalInt(oPC, "fear");

if (DoOnce==TRUE) return;
SetLocalInt(oPC, "fear", TRUE);

if (WillSave(oPC, 69, SAVING_THROW_TYPE_FEAR ))
   {
   FloatingTextStringOnCreature("You have overcome your fear, but doubt remains as you approach, sensing that certain death draws nigh.", oPC);
   }
else
   {
   effect eFear = EffectFrightened();
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oPC, 300.0f);
   FloatingTextStringOnCreature("Frozen with fear, your heart beats rapidly, and your legs begin to tremble uncontrollably, as you panic from the sight of such uncertainty.", oPC);
   }
}
