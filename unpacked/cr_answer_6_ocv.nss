void main()
{
    int iListen = GetListenPatternNumber();
    location lStartLoc = GetLocation(OBJECT_SELF);

    if (iListen == 101) // listen pattern set in s_listener
    {
        string sPassword = GetMatchedSubstring(0);
        sPassword = GetStringLowerCase(sPassword);

        if (sPassword == "word" || sPassword == "bong")  //So close...
        {
            SendMessageToPC(GetLastSpeaker(),"You think you see the Riddle Keeper shake her head. You feel you're close, but not quite there.");
        }
/*
        if (sPassword == "water bong" || sPassword == "matches")  //So close...
        {
            SendMessageToPC(GetLastSpeaker(),"You think you see the Riddle Keeper grin and shake her shoulders, like she's trying to hold back laughter.");
        }
*/
        if (sPassword == "letters" || sPassword == "pipe" || sPassword == "Pipe" || sPassword == "PIPE" || sPassword == "Hookah" || sPassword == "hookah" || sPassword == "tabacco pipe") // this checks to see if the password was said
        {

            object oDoor = GetObjectByTag("RIDDLEDOOR6"); // this is the door to be unlocked
            SetLocked(oDoor, FALSE);
            ActionOpenDoor(oDoor);
            ActionMoveToLocation(lStartLoc,TRUE); // his job is done

        };
    };
}

