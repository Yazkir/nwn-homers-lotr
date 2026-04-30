/*
    s_moduserdef - Incorporate this code into Module::OnUserDefined
*/

void main()
{

switch (GetUserDefinedEventNumber()) {

case 200:
/*
    Export all characters every 'n' seconds. Note that this event triggers
    itself, on a timer, when finished -- until the module is unloaded.
*/
    ExportAllCharacters();
    //SpeakString(", TALKVOLUME_SHOUT);
    DelayCommand(1500.0, SignalEvent(OBJECT_SELF, EventUserDefined(200)));
    break;

case 220:
/*
    Export all characters every 'n' seconds. Note that this event triggers
    itself, on a timer, when finished -- until the module is unloaded.
*/
    ExportAllCharacters();
    //SpeakString(" ", TALKVOLUME_SHOUT);

}  /* switch  */

}
