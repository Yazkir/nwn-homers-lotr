//Gets pattern and checks to see if its the phrase that has been defined
void main()
{
    int pattern = GetListenPatternNumber();

    switch(pattern) //Check to see if Correct Answer was recieved
        {
            case 69:
                ActionSpeakString("Gotcha");
                ActionWait(6.0);
                ActionSpeakString("Rounds Up!!");
                break;
        }
}
