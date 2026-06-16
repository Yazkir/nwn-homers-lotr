// Paths of the Dead -- the "go dark" path. The player threatens Aragorn to take
// Anduril by force; he refuses and the conversation ends in a fight. Slaying him
// and/or looting the blade records the dark path (see arag_ondeath / acquireditem_tag).
void main()
{
    object oPC = GetPCSpeaker();
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 10);
    SetIsTemporaryEnemy(oPC, OBJECT_SELF);
    AssignCommand(OBJECT_SELF, ActionAttack(oPC));
}
