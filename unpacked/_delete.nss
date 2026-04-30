 #include "_deletex"

void main()
{
  object oPC = GetPCSpeaker();
  effect tice = EffectVisualEffect(VFX_DUR_ICESKIN);
  effect tinferno = EffectVisualEffect(VFX_DUR_INFERNO);
  effect tgate = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
  effect tsmoke = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
  effect tharm = EffectVisualEffect(VFX_IMP_HARM);
  if (GetIsPossessedFamiliar(oPC)) {
    SendMessageToPC(oPC,"You may only delete yourself when you are not possessing your familiar!");
    return;
  }

  if (GetIsDM(oPC) || GetIsDMPossessed(oPC)) {
    SendMessageToPC(oPC,"DMs are not servervault characters, and therefore may not be deleted!");
    return;
  }

  string pname = GetPCPlayerName(oPC);
  string cname = GetName(oPC);

  FloatingTextStringOnCreature ("Character Deleted",oPC);
  DelayCommand(0.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, tinferno, oPC));
  DelayCommand(5.5,BootPC(oPC));
  DelayCommand(6.0,deletechar(pname, cname));
}
