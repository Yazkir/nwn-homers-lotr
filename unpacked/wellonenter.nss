void main()
{
    object oPC = GetEnteringObject();
    int iXP = GetXP(oPC);
    if((iXP == 0) && !(GetIsDM(oPC)))
    {
        GiveXPToCreature(oPC, 3000);
    }
}
