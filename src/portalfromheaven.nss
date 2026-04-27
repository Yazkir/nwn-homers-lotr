void main()
{
object  user=GetLastUsedBy();
string sSound1 = GetLocalString(OBJECT_SELF, "CEP_L_SOUND1");
string sSound2 = GetLocalString(OBJECT_SELF, "CEP_L_SOUND2");
    if (GetLocalInt(OBJECT_SELF,"CEP_L_AMION") == 0)
    {
        object oSelf = OBJECT_SELF;
        PlaySound(sSound1);
        DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
        SetLocalInt(OBJECT_SELF,"CEP_L_AMION",1);
    }
    else
    {
        object oSelf = OBJECT_SELF;
        PlaySound(sSound2);
        DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
        SetLocalInt(OBJECT_SELF,"CEP_L_AMION",0);
    }
int nMyLevels = GetHitDice(user);
if (nMyLevels >= 16)
    {
    object target=GetObjectByTag("WP_From_Heaven");
    AssignCommand(user,ClearAllActions());
    AssignCommand(user,ActionJumpToObject(target));
    }
    else
    {
    SpeakString( "You do not meet level requirements to access this portal " + "." );
    }
}

