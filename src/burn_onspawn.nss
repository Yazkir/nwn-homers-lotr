void hit(object oTarget)
{
ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_COM_HIT_FIRE),oTarget);
DelayCommand(1.5,hit(OBJECT_SELF));
}

void main()
{
DelayCommand(1.5,hit(OBJECT_SELF));
}
