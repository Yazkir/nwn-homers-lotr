void main()
{
    int iListen = GetListenPatternNumber();
    location lStartLoc = GetLocation(OBJECT_SELF);

    if (iListen == 101) // listen pattern set in s_listener
    {
        string sPassword = GetMatchedSubstring(0);
        sPassword = GetStringLowerCase(sPassword);

        if (sPassword == "air" || sPassword == "the air" || sPassword == "hurricane" || sPassword == "tornado" || sPassword == "sotrm")  //So close...
        {
            SendMessageToPC(GetLastSpeaker(),"You think you see the Riddle Keeper wink at you. You feel you're close, but not quite there.");
        }

        if (sPassword == "fart" || sPassword == "a fart")  //So close...
        {
            SendMessageToPC(GetLastSpeaker(),"You think you see the Riddle Keeper grin and shake her shoulders, like she's trying to hold back laughter.");
        }

        if (sPassword == "wind" || sPassword == "the wind" || sPassword == "winds" ) // this checks to see if the password was said
        {

            object oDoor = GetObjectByTag("RIDDLEDOOR5"); // this is the door to be unlocked
            SetLocked(oDoor, FALSE);
            ActionOpenDoor(oDoor);
            ActionMoveToLocation(lStartLoc,TRUE); // his job is done

        };
    };
}

