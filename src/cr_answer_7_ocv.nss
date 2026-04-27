void main()
{
    int iListen = GetListenPatternNumber();
    location lStartLoc = GetLocation(OBJECT_SELF);

    if (iListen == 101) // listen pattern set in s_listener
    {
        string sPassword = GetMatchedSubstring(0);
        sPassword = GetStringLowerCase(sPassword);

        if (sPassword == "links" || sPassword == "link" || sPassword == "rope" || sPassword == "ropes")  //So close...
        {
            SendMessageToPC(GetLastSpeaker(),"You think you see the Riddle Keeper shake her head. You feel you're close, but not quite there.");
        }

        if (sPassword == "chain" || sPassword == "chains" || sPassword == "a chain" ) // || sPassword == "letters of the alphabet" || sPassword == "alphabet" || sPassword == "the alphabet" || sPassword == "the letters of the alphabet") // this checks to see if the password was said
        {

            object oDoor = GetObjectByTag("RIDDLEDOOR7"); // this is the door to be unlocked
            SetLocked(oDoor, FALSE);
            ActionOpenDoor(oDoor);
            ActionMoveToLocation(lStartLoc,TRUE); // his job is done

        };
    };
}

