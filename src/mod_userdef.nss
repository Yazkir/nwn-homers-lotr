void main()
{

switch (GetUserDefinedEventNumber()) {

case 200:

    ExportAllCharacters();
    SpeakString("<các>Visit the Website at", TALKVOLUME_SHOUT);
    SpeakString("<các>Legend.nwnforums.com", TALKVOLUME_SHOUT);
    DelayCommand(1500.0, SignalEvent(OBJECT_SELF, EventUserDefined(200)));
    break;

case 220:

    ExportAllCharacters();
    SpeakString("<các>Visit the Website at", TALKVOLUME_SHOUT);
    SpeakString("<các>Legend.nwnforums.com", TALKVOLUME_SHOUT);
    DelayCommand(1500.0, SignalEvent(OBJECT_SELF, EventUserDefined(200)));
    break;
}

}

//http://www.createphpbb.com/phpbb/index.php?mforum=nwlegendwaker
