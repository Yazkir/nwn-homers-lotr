////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_tset  - This script sets the      //
//  module time, executed from            //
//  kpb_onheartbeat.                      //
//  Included from Zyzko's script.         //
////////////////////////////////////////////
void main()
{
    object oMod=GetModule();
    SetCampaignInt("kpb_calendar","TIMEHOUR",GetTimeHour(),oMod);
    SetCampaignInt("kpb_calendar","TIMEDAY",GetCalendarDay(),oMod);
    SetCampaignInt("kpb_calendar","TIMEMONTH",GetCalendarMonth(),oMod);
    SetCampaignInt("kpb_calendar","TIMEYEAR",GetCalendarYear(),oMod);
}
