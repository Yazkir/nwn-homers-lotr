void main()
{
    effect eVisEffect = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    object oArea = GetArea(OBJECT_SELF);
    location lTarget,lEffectTarget;
    int x,y;
    vector vNewVector;


    if(GetLocalInt(OBJECT_SELF,"IS_ACTIVE") == 0)
    {
        for(y=0;y<4;++y)
        {
            lTarget = GetLocation(GetObjectByTag("WP_SummanusEffect" + IntToString(y)));

            for(x=0;x<8;++x)
            {
                vNewVector = GetPositionFromLocation(lTarget);

                vNewVector.x += Random(10) - 5;
                vNewVector.y += Random(10) - 5;

                lEffectTarget = Location(oArea,vNewVector,0.0);

                DelayCommand( (x * 0.25) ,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisEffect,lEffectTarget));
            }
        }
    SetLocalInt(OBJECT_SELF,"IS_ACTIVE",1);
    DelayCommand(480.0,SetLocalInt(OBJECT_SELF,"IS_ACTIVE",0));

    }
}
