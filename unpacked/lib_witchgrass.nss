//include file for the bud


int GetHigh(object oSmoker){
    float duration = HoursToSeconds(1);
    string comment;
{
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(10), oSmoker, duration);
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_SPOT,5), oSmoker, duration);
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_LISTEN,5), oSmoker, duration);
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_WISDOM,4), oSmoker, duration);
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE,2), oSmoker, duration);
         RemoveEffect( oSmoker, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
        DelayCommand(2.f,ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED), oSmoker, duration-2.0f));

        switch(d6()){
        case 1:
            comment="cough, cough";
            break;
        case 2:
            comment="Oh, yeah. This is the good stuff.";
            DelayCommand(2.f,AssignCommand(oSmoker,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0f,3.0f)));
            break;
        case 3:
            comment="Woah. Heh, heh. I feel like I'm floating.";
            DelayCommand(2.f,AssignCommand(oSmoker,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0f,3.0f)));
            break;
        case 4:
            comment="Um, where was I going?";
            DelayCommand(3.f,ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectConfused(), oSmoker, RoundsToSeconds(d4())));
            break;
        case 5:
            comment="Whoah! Contact high.";
            DelayCommand(3.f,ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectConfused(), oSmoker, RoundsToSeconds(d4())));
            break;
        case 6:
            comment="Dude, I got the munchies, hardcore.";
            DelayCommand(3.f,ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectConfused(), oSmoker, RoundsToSeconds(d4())));
            break;
        }
        DelayCommand(2.f,AssignCommand(oSmoker,ActionSpeakString(comment)));
        return 1;
    }
}


