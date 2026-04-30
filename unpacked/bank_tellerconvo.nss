void main()
{
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    object oIntruder;

    if (nMatch == -1 && GetCommandable(OBJECT_SELF))
    {
        ClearAllActions();
        BeginConversation();
    }

    //Make sure it's not an NPC
    if(GetIsPC(oShouter) == FALSE)
        return;

    //Withdrawing gold
    if(nMatch == 17)
    {
        //First parse the string to find the amount of gold
        string sGold = GetMatchedSubstring(2);
        int gold = StringToInt(sGold);
        int balance = GetCampaignInt("Bank", "BankGold", oShouter);

        if(balance == 0)
        {
            SpeakString("You don't have any gold to withdraw.");
            return;
        }

        //First check to see if the gold value is valid
        if(gold <= 0)
            SpeakString("I don't understand, try saying it again.");
        else if(gold > balance)
            SpeakString("You don't have that much in your balance.");
        else
        {
            //It's valid, so withdraw
            balance -= gold;
            SetCampaignInt("Bank", "BankGold", balance, oShouter);
            SpeakString("Withdraw complete.");

            GiveGoldToCreature(oShouter, gold);
        }
    }

    //Depositing gold
    if(nMatch == 18)
    {
        //Parse the string
        string sGold = GetMatchedSubstring(2);
        int gold = StringToInt(sGold);
        int balance = GetCampaignInt("Bank", "BankGold", oShouter);
        int pcgold = GetGold(oShouter);

        //Check to see if it's valid
        if(pcgold == 0)
        {
            SpeakString("You don't have any gold to deposit.");
            return;
        }

        if(gold > pcgold)
            SpeakString("You don't have that much gold.");
        else if(gold <= 0)
            SpeakString("I didn't understand that, try again.");
        else
        {
            balance += gold;
            SetCampaignInt("Bank", "BankGold", balance, oShouter);
            SpeakString("Deposit complete.");

            TakeGoldFromCreature(gold, oShouter, TRUE);
        }
    }
}
