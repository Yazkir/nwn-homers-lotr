#include "x2_inc_toollib"

#include "x2_inc_spellhook"
void main()
{

    /*
      Spellcast Hook Code
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    int nDuration = 30;
    effect eSummon;
    effect eVis = EffectVisualEffect(460);
    eSummon = EffectSummonCreature("Scarecrow",481,0.0f,TRUE);

    // * make it so Pet Rock cannot be dispelled
    eSummon = ExtraordinaryEffect(eSummon);
    //Apply the summon visual and summon the dragon.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,GetSpellTargetLocation(), RoundsToSeconds(nDuration));
    DelayCommand(1.0f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,GetSpellTargetLocation()));
}


