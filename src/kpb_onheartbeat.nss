////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_onheartbeat - This script makes   //
//  the module save the time and date for //
//  the module.                           //
//  Included from Zyzko's script.         //
//  Note: This script can be altered to   //
//  be used as an OnRest event or other   //
//  type of event if, even though a small //
//  heartbeat, you do not wish to use a   //
//  heartbeat event.                      //
////////////////////////////////////////////
void main()
{
    object oMod=GetModule();
    int iCurrentHour = GetTimeHour();
    int nCurrentMinute = GetTimeMinute();
    int nCurrentSecond = GetTimeSecond();
    int nCurrentMilli = GetTimeMillisecond();
    SetTime(iCurrentHour, nCurrentMinute, nCurrentSecond, nCurrentMilli);

    if (GetLocalInt(oMod, "CheckHour") != GetTimeHour())
    {
        SetLocalInt(oMod, "CheckHour", GetTimeHour());
        ExecuteScript("kpb_tset", oMod);
    }
}
