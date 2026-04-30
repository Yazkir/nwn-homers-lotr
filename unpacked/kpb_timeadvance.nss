void main()
{
int current_hour = GetTimeHour();
    int nMinute = GetTimeMinute();
    int nSecond = GetTimeSecond();
    int nMillisecond = GetTimeMillisecond();

    int new_hour = current_hour + 24 ;
    SetTime(new_hour,nMinute,nSecond,nMillisecond);
}
