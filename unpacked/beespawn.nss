// spawn for beez, lets hope it looks nice.?

void BurningObject(object oTarget)
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_COM_SPARKS_PARRY),oTarget);
DelayCommand(1.5,BurningObject(OBJECT_SELF));
}

void Buzz(object oTarget)
{
AssignCommand(OBJECT_SELF, ActionSpeakString("Bzzzz"));
DelayCommand(8.5,BurningObject(OBJECT_SELF));
}

void main()
{
DelayCommand(1.5,BurningObject(OBJECT_SELF));
DelayCommand(8.5,Buzz(OBJECT_SELF));
}
