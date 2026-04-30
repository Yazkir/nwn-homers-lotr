/*
    s_modload - Incorporate this code into Module::OnLoad
*/

void main()
{

/* Start the export characters timer */
DelayCommand(1500.0, SignalEvent(OBJECT_SELF, EventUserDefined(200)));

DelayCommand(14100.0, SignalEvent(OBJECT_SELF, EventUserDefined(220)));

}
