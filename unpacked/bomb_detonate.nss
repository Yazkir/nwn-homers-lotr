
void main()
{
object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 15.0,  GetLocation(OBJECT_SELF), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL),OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY),OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(999),OBJECT_SELF);

 while(GetIsObjectValid(oTarget))
  {
  if(GetTag(oTarget)=="ZEP_STONES011")
     {
     DestroyObject (oTarget);
     }
   if (GetIsReactionTypeFriendly(oTarget))
    {
   ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(999),oTarget);
    }
     else
      {
       ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(999),oTarget);
      }

oTarget = GetNextObjectInShape(SHAPE_SPHERE, 15.0, GetLocation(OBJECT_SELF),OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);



  }
}
