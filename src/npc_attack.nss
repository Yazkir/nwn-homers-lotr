void main()
{
object oPC= GetLastUsedBy();
object oChair= OBJECT_SELF;

effect eLove= EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
effect eLove1= EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
effect eLove2= EffectVisualEffect(VFX_IMP_LIGHTNING_M );
effect eLove3= EffectVisualEffect(VFX_IMP_GOOD_HELP);
effect eLove4= EffectVisualEffect(VFX_FNF_SUMMONDRAGON);
effect eLove5= EffectVisualEffect(VFX_IMP_SONIC);
effect eLove6= EffectVisualEffect( VFX_FNF_SUMMON_UNDEAD);
string sMessage1= "Iz In De Houze";
if(GetIsPC(oPC))
 {
 if(GetIsObjectValid(oChair)&& !GetIsObjectValid(GetSittingCreature(oChair))&& GetPCPlayerName(oPC)== "!___________________________________________________________________________!")
  {
  ActionDoCommand(PlaySound(""));


  AssignCommand(oPC,ActionSit(oChair));





  DelayCommand(5.1,AssignCommand(oChair,ActionSpeakString(sMessage1,TALKVOLUME_TALK)));
  DelayCommand(5.2,ApplyEffectToObject(DURATION_TYPE_INSTANT,eLove5,oChair));
  DelayCommand(5.2,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLove6,oChair, 120.0));
  }
 }
 {
 effect eSpike0= EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
 effect eSpike1= EffectVisualEffect(VFX_IMP_GOOD_HELP);
 effect eSpike2= EffectVisualEffect(VFX_FNF_HOWL_MIND);
 effect eSpike3= EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
 effect eGore= EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
 effect eDeath= EffectDeath(TRUE);

 string sMessage2= "I Dont Think So Do You?";
 if(GetIsObjectValid(oChair)&& !GetIsObjectValid(GetSittingCreature(oChair))&& GetPCPlayerName(oPC)!= "!___________________________________________________________________________!")
  {


  AssignCommand(oPC,ActionSit(oChair));



  DelayCommand(2.2,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSpike1,oPC));
  DelayCommand(2.2,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSpike2,oPC));
  DelayCommand(2.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSpike3,oPC));
  DelayCommand(3.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eGore,oPC));
  DelayCommand(3.8,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oPC));
  DelayCommand(3.8,ActionDoCommand(PlaySound("")));
  DelayCommand(4.7,AssignCommand(oPC,ActionSpeakString(sMessage2,TALKVOLUME_TALK)));
{
object oPC= GetLastUsedBy();
object oThrone= OBJECT_SELF;
string name = GetName(oPC);

if(GetIsPC(oPC))
 {
 if(GetIsObjectValid(oThrone)&& !GetIsObjectValid(GetSittingCreature(oThrone))&& GetPCPublicCDKey(oPC)== "" || GetPCPublicCDKey(oPC) ==  "")
  {
  AssignCommand(oPC,ActionSit(oThrone));
  }
 }
 {
 effect eDeath= EffectDeath(TRUE,TRUE);
 effect eFt1= EffectVisualEffect(235);
 effect eFt2= EffectVisualEffect(99);
 effect eFt3= EffectVisualEffect(246);
 effect eFt4= EffectVisualEffect(34);

 if(GetIsObjectValid(oThrone)&& !GetIsObjectValid(GetSittingCreature(oThrone))&& GetPCPublicCDKey(oPC)!= "" && GetPCPublicCDKey(oPC) !=  "")
  {
  StoreCameraFacing();
  SetCutsceneMode(oPC, TRUE);
  DelayCommand(0.0,AssignCommand(oPC,SetCameraFacing(-40.0,24.0,20.0,CAMERA_TRANSITION_TYPE_VERY_FAST)));
  DelayCommand(0.5,AssignCommand(oPC,ActionSit(oThrone)));
  DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eFt4,oPC));
  DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eFt1,oPC));
  DelayCommand(3.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eFt3,oPC));
  DelayCommand(3.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eFt1,oPC));
  DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eFt2,oPC));
  DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eFt1,oPC));
  DelayCommand(4.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eFt1,oPC));
  DelayCommand(4.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oPC));
  DelayCommand(4.4,SetCutsceneMode(oPC, FALSE));
  }
 }
}

  }
 }
}
