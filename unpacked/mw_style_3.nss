// mw_style_3 -- set combat style 3 (Counterspell).
// Caster guides ready counterspells against enemy mages instead of nuking/healing.
// Used by Peterson, Watts, Campbell, McKenna, and Aurelius.
void main()
{
    SetLocalInt(OBJECT_SELF, "MW_STYLE", 3);
    object oMaster = GetMaster();
    if (GetIsObjectValid(oMaster))
        FloatingTextStringOnCreature("I will turn their magic against them.", oMaster, FALSE);
}
