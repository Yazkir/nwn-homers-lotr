#include "x2_inc_switches"
void main()
{
int nEvent =GetUserDefinedItemEventNumber();
switch (nEvent)
   {
   case X2_ITEM_EVENT_ACTIVATE:
ExecuteScript("ac_"+GetTag(GetItemActivated()),
OBJECT_SELF); break;
   case X2_ITEM_EVENT_EQUIP:
ExecuteScript("eq_"+GetTag(GetPCItemLastEquipped()),
OBJECT_SELF); break;
   case X2_ITEM_EVENT_UNEQUIP:
ExecuteScript("ue_"+GetTag(GetPCItemLastUnequipped())
, OBJECT_SELF); break;
   case X2_ITEM_EVENT_ACQUIRE:
ExecuteScript("aq_"+GetTag(GetModuleItemAcquired()),
OBJECT_SELF); break;
   case X2_ITEM_EVENT_UNACQUIRE:
ExecuteScript("ua_"+GetTag(GetModuleItemLost()),
OBJECT_SELF); break;
   case X2_ITEM_EVENT_SPELLCAST_AT:
ExecuteScript("sp_"+GetTag(GetModuleItemLost()),
OBJECT_SELF); break;
   case X2_ITEM_EVENT_ONHITCAST:
ExecuteScript("on_"+GetTag(GetSpellCastItem()),
OBJECT_SELF); break;
   }
}

