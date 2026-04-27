void main()
{

SetListening( OBJECT_SELF, TRUE);
SetListenPattern( OBJECT_SELF, "**",101);


//Fix it so he can hear invisible characters
ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectUltravision(), OBJECT_SELF, 99999.9);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTrueSeeing(), OBJECT_SELF, 99999.9);

}
