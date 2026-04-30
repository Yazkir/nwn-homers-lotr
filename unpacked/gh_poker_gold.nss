/*
    Simple Poker game. 5 card draw.
    By: Joe Leonard
    Email: aiden_00@yahoo.com
    Created: 10-10-02
*/

#include "gh_poker_include"

int StartingConditional()
{
    if(GetGold(GetPCSpeaker()) >= 500) { //5oo being the minimum bet, check to make sure PC has enough.
        return TRUE;
    }
    else {
        SendMessageToPC(GetPCSpeaker(), "You lack the funds to play or make more bets.");
        return FALSE;
    }
}
