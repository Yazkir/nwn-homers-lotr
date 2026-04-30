//:://////////////////////////////////////////////
//:: Pc Builder V2 (DESTROY_EQUIPT_ITEMS)
//::Createt by : BUTCHA
//:://////////////////////////////////////////////
void main()
{
object oPC = GetLastSpeaker();
object oItem1  = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
object oItem2  = GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
object oItem3  = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
object oItem4  = GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
object oItem5  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
object oItem6  = GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
object oItem7  = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
object oItem8  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
object oItem9  = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
object oItem10 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
object oItem11 = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
object oItem12 = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
object oItem13 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
object oItem14 = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
AssignCommand(OBJECT_SELF,ActionCastFakeSpellAtObject(SPELL_EPIC_RUIN,oPC,PROJECTILE_PATH_TYPE_DEFAULT));
DelayCommand(2.0,DestroyObject(oItem1));
DelayCommand(2.0,DestroyObject(oItem2));
DelayCommand(2.0,DestroyObject(oItem3));
DelayCommand(2.0,DestroyObject(oItem4));
DelayCommand(2.0,DestroyObject(oItem5));
DelayCommand(2.0,DestroyObject(oItem6));
DelayCommand(2.0,DestroyObject(oItem7));
DelayCommand(2.0,DestroyObject(oItem8));
DelayCommand(2.0,DestroyObject(oItem9));
DelayCommand(2.0,DestroyObject(oItem10));
DelayCommand(2.0,DestroyObject(oItem11));
DelayCommand(2.0,DestroyObject(oItem12));
DelayCommand(2.0,DestroyObject(oItem13));
DelayCommand(2.0,DestroyObject(oItem14));
DelayCommand(2.0,FloatingTextStringOnCreature("Equipt Items Destroyt",oPC));
}
