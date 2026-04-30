void main()
{

object oPC = GetLastOpenedBy();

if (!GetIsPC(oPC)) return;

DelayCommand(20.0, ActionCloseDoor(OBJECT_SELF));

DelayCommand(20.5, SetLocked(OBJECT_SELF, TRUE));

}

