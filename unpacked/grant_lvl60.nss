void main()
{
    object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;
    SetXP(oPC, 17498600);
    FloatingTextStringOnCreature("XP set to 17498600.", oPC, FALSE);
}
