/*
    Simple Poker game. 5 card draw.
    By: Joe Leonard
    Email: aiden_00@yahoo.com
    Created: 10-10-02
*/

void main()
{
    //Adds minimum bet to pot.
    //If pot is 10, adds players bet, plus calls for the dealers.
    TakeGoldFromCreature(GetLocalInt(OBJECT_SELF, "MINIMUM_BET"), GetPCSpeaker(), FALSE);
    SetLocalInt(OBJECT_SELF, "MONEY_POT", GetLocalInt(OBJECT_SELF, "MONEY_POT") + (GetLocalInt(OBJECT_SELF, "MINIMUM_BET") * 2));

    //Turn on the discard round.
    SetLocalInt(OBJECT_SELF, "DISCARD_TIME", TRUE);
}
