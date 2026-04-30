// Returns the PC to normal appearance.
void main()
{
    object oPC = GetLastSpeaker();
    int iRace = GetRacialType(oPC);

    if (iRace == IP_CONST_RACIALTYPE_DWARF)
    {
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_DWARF);
    }
    else if (iRace == IP_CONST_RACIALTYPE_ELF)
    {
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_ELF);
    }
    else if (iRace == IP_CONST_RACIALTYPE_GNOME)
    {
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_GNOME);
    }
    else if (iRace == IP_CONST_RACIALTYPE_HALFELF)
    {
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HALF_ELF);
    }
    else if (iRace == IP_CONST_RACIALTYPE_HALFLING)
    {
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HALFLING);
    }
    else if (iRace == IP_CONST_RACIALTYPE_HALFORC)
    {
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HALF_ORC);
    }
    else if (iRace == IP_CONST_RACIALTYPE_HUMAN)
    {
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_HUMAN);
    }
}
