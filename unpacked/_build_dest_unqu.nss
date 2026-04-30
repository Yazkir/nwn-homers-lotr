//:://////////////////////////////////////////////
//:: Pc Builder V2 (DESTROY_UNEQUIPT_ITEMS)
//::Createt by : BUTCHA
//:://////////////////////////////////////////////
void main()
{
object oPC = GetLastSpeaker();
object oItem = GetFirstItemInInventory(oPC);
AssignCommand(OBJECT_SELF,ActionCastFakeSpellAtObject(SPELL_EPIC_RUIN,oPC,PROJECTILE_PATH_TYPE_DEFAULT));
while(oItem != OBJECT_INVALID)
{
oItem = GetNextItemInInventory(oPC);
DelayCommand(2.0,DestroyObject(oItem));
}
DelayCommand(2.0,FloatingTextStringOnCreature("Unequipt Items Destroyt",oPC));
}
