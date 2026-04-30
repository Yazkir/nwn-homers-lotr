//::///////////////////////////////////////////////
//::ULTIMATE PC BUILDER V2
//::APPEARANCE GNOME
//:: CREATET BY BUTCHA(MoD)
//:://////////////////////////////////////////////
void main()
{
object oPC = GetLastSpeaker();
AssignCommand(OBJECT_SELF,ActionCastFakeSpellAtObject(SPELL_WORD_OF_FAITH,oPC,PROJECTILE_PATH_TYPE_DEFAULT));
DelayCommand(2.0,SetCreatureAppearanceType(oPC,APPEARANCE_TYPE_GNOME));
DelayCommand(2.0,FloatingTextStringOnCreature("Apperance Gnome",oPC));
}
