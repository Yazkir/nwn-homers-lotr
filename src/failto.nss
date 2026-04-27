void main()
{

object oPC = GetClickingObject();

if (!GetIsPC(oPC)) return;

if (GetHitDice(oPC) < 40)
   return;

SetLocked(OBJECT_SELF, FALSE);

ActionOpenDoor(OBJECT_SELF);

}
