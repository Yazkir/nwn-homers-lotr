#include "x2_inc_switches"

void main()
{
     //Is it day? If so, disallow spells
     if (GetIsDay())
     {
          SetModuleOverrideSpellScriptFinished();
          SendMessageToPC(OBJECT_SELF, "Spell can not be casted in the Well.");
     }
}
