/*
    Simple Poker game. 5 card draw.
    By: Joe Leonard
    Email: aiden_00@yahoo.com
    Created: 10-10-02

    After discard round, show the hand to the player including his new cards
    he got from discarding. Also turn off "discard time" so the NPC will not
    respond to 'talk'.
    Dealer also discards his cards at this point.
*/
#include "gh_poker_include"

void main()
{
    object oPC = GetPCSpeaker();

    SetLocalInt(OBJECT_SELF, "DISCARD_TIME", FALSE); //Turn off discard time.

    //Discard player cards.
    int iCount;
    for(iCount = 1; iCount <= 5; iCount++) { //Interate through the 5 cards in the hand.
        if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(iCount)) > 0) { //If discard is NOT 0...
            SetLocalInt(OBJECT_SELF, "PLAYER_CARD_" + IntToString(iCount), Deal()); //..Deal a NEW card in this spot.
        }
    }

    //Discard dealer cards.
    for(iCount = 1; iCount <= 5; iCount++) { //Interate through the 5 cards in the hand.
        if(GetLocalInt(OBJECT_SELF, "DEALER_DISCARD_" + IntToString(iCount)) > 0) { //If discard is NOT 0...
            SetLocalInt(OBJECT_SELF, "DEALER_CARD_" + IntToString(iCount), Deal()); //..Deal a NEW card in this spot.
        }
    }

    SendMessageToPC(oPC, "The pot is: " + IntToString(GetLocalInt(OBJECT_SELF, "MONEY_POT")));
    SendMessageToPC(oPC, ShowHandAndScores("PLAYER"));
}
