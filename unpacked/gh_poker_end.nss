/*
    Simple Poker game. 5 card draw.
    By: Joe Leonard
    Email: aiden_00@yahoo.com
    Created: 10-10-02

    This code is the end of the poker game. It determines a winner by comparing
    the scores of the hands as updated by the call to 'ShowHandAndScores()'.
    It shows both the players hand, and dealers hand at this point. The pot is
    awarded to the PC if he wins.
*/
#include "gh_poker_include"

void main()
{
    object oPC = GetPCSpeaker();

    //Update cards to player and dealer.
    SendMessageToPC(oPC, "The pot is: " + IntToString(GetLocalInt(OBJECT_SELF, "MONEY_POT")));
    SendMessageToPC(oPC, ShowHandAndScores("PLAYER"));
    SendMessageToPC(oPC, ShowHandAndScores("DEALER"));

    //Find a winner!
    if(GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_MAIN") > GetLocalInt(OBJECT_SELF, "DEALER_SCORE_MAIN")) {
        //Player wins. Main score is higher than dealer main score.
        SendMessageToPC(oPC, "Winner: Player!");
        SpeakString("My, my, you win sir, fine game.");
        GiveGoldToCreature(oPC, GetLocalInt(OBJECT_SELF, "MONEY_POT"));
    }
    else if(GetLocalInt(OBJECT_SELF, "DEALER_SCORE_MAIN") > GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_MAIN")) {
        //Dealer wins. Main score is higher than player main score.
        SendMessageToPC(oPC, "Winner: Dealer!");
        SpeakString("I do believe I win. How fortuitous.");
    }
    else if(GetLocalInt(OBJECT_SELF, "DEALER_SCORE_MAIN") == GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_MAIN")) {
        //Tie. Main scores are tied, proceed to check first scores.
        if(GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_FIRST") > GetLocalInt(OBJECT_SELF, "DEALER_SCORE_FIRST")) {
            //Player wins. First score is higher than dealer main score.
            SendMessageToPC(oPC, "Winner: Player!");
            SpeakString("How strange, you win. My congratulations.");
            GiveGoldToCreature(oPC, GetLocalInt(OBJECT_SELF, "MONEY_POT"));
        }
        else if(GetLocalInt(OBJECT_SELF, "DEALER_SCORE_FIRST") > GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_FIRST")) {
            //Dealer wins. First score is higher than player main score.
            SendMessageToPC(oPC, "Winner: Dealer!");
            SpeakString("You came close my friend, but I do believe the game is mine.");
        }
        else if(GetLocalInt(OBJECT_SELF, "DEALER_SCORE_FIRST") == GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_FIRST")) {
            //Tie. First scores are tied, proceed to check second scores.
            if(GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_SECOND") > GetLocalInt(OBJECT_SELF, "DEALER_SCORE_SECOND")) {
                //Player wins. Second score is higher than dealer main score.
                SendMessageToPC(oPC, "Winner: Player!");
                SpeakString("A close one, you win.");
                GiveGoldToCreature(oPC, GetLocalInt(OBJECT_SELF, "MONEY_POT"));
            }
            else if(GetLocalInt(OBJECT_SELF, "DEALER_SCORE_SECOND") > GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_SECOND")) {
                //Dealer wins. Second score is higher than player main score.
                SendMessageToPC(oPC, "Winner: Dealer!");
                SpeakString("A close one, but my skill prevails.");
            }
            else if(GetLocalInt(OBJECT_SELF, "DEALER_SCORE_SECOND") == GetLocalInt(OBJECT_SELF, "PLAYER_SCORE_SECOND")) {
                //Tie. Main, First and Second scores all tied. Game is a tie!
                SendMessageToPC(oPC, "TIE!");
                SpeakString("A tie? My, my, we shall have to play again my friend.");
            }
        }
    }

    //Reset the pot.
    SetLocalInt(OBJECT_SELF, "MONEY_POT", 0);

    //Set player as NOT "PLAYING".
    SetLocalInt(oPC, "IS_PLAYING_POKER", FALSE);
}



