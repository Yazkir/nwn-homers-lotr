/*
    Simple Poker game. 5 card draw.
    By: Joe Leonard
    Email: aiden_00@yahoo.com
    Created: 10-10-02

    Doc Holliday userdefined event, OnConversation.
    This is used to respond to the players requests to discard cards.
*/
#include "gh_poker_include"

void main() {
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1004) { //OnConversation.
        int nMatch = GetListenPatternNumber();
        object oPC = GetLastSpeaker();

        //If the player who spoke, is playing, and its "discard time", proceed...
        if(GetLocalInt(oPC, "IS_PLAYING_POKER") && GetLocalInt(OBJECT_SELF, "DISCARD_TIME")) {
            switch(nMatch) {
                case 3001:
                    nMatch = 1; //Card 1
                    break;
                case 3002:
                    nMatch = 2; //Card 2
                    break;
                case 3003:
                    nMatch = 3; //Card 3
                    break;
                case 3004:
                    nMatch = 4; //Card 4
                    break;
                case 3005:
                    nMatch = 5; //Card 5
                    break;
                case 3006:
                    nMatch = 6; //Card 5
                    break;
                case 3007:
                    nMatch = 7; //Card 5
                    break;
                case 3008:
                    nMatch = 8; //Card 5
                    break;
                case 3009:
                    nMatch = 9; //Card 5
                    break;
                case 3010:
                    nMatch = 10; //Card 5
                    break;
                default:
                    SpeakString("I should never say this!");
                    break;
            }
            if(nMatch <= 5) { //Player is discarding.
                //If 3 or more cards discarded.. dont continue.
                if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_1") + //Discarded cards == 1, so if the total is greater than 2, don't continue.
                    GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_2") +
                    GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_3") +
                    GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_4") +
                    GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_5") <= 2) {
                        if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(nMatch)) == FALSE) { //If the slot has not already been discarded.
                            //Removing for added feature. SetLocalInt(OBJECT_SELF, "PLAYER_CARD_" + IntToString(nMatch), Deal()); //Deal a new card in that slot.
                            SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(nMatch), 1); //Set as discarded
                            //When showing the players hand below, hide cards that have been marked as "discarded" as the
                            //player should not see what card he recieved back, UNTIL he has discarded ALL the cards he was going to discard.
                            SendMessageToPC(oPC, ShowHandAndScores("PLAYER")); //Output hand to player.
                        }
                        else { //Else that card has been discarded already.
                            SendMessageToPC(oPC, "You've already discarded that card!");
                        }
                }
                else if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_1") + //Discarded cards == 1, so if the total is greater than 3, don't continue.
                        GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_2") +
                        GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_3") +
                        GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_4") +
                        GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_5") <= 3) {
                            if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(nMatch)) == FALSE) { //If the slot has not already been discarded.
                                int iCount = 0;
                                int iCard1 = 0;
                                int iCard2 = 0;
                                for(iCount = 1; iCount <= 5; iCount++) { //Set iCard1 and iCard2 to the two leftover cards that have not been discarded.
                                    if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(iCount)) == 0) {
                                        if(iCard1 == 0) {
                                            iCard1 = GetLocalInt(OBJECT_SELF, "PLAYER_CARD_" + IntToString(iCount));
                                        }
                                        else {
                                            iCard2 = GetLocalInt(OBJECT_SELF, "PLAYER_CARD_" + IntToString(iCount));
                                        }
                                    }
                                }
                                SpeakString(IntToString(iCard1) + "   " + IntToString(iCard2));
                                if((GetLocalInt(OBJECT_SELF, "PLAYER_CARD_" + IntToString(nMatch)) == iCard1 &&
                                    iCard2 >= 49) ||
                                    (GetLocalInt(OBJECT_SELF, "PLAYER_CARD_" + IntToString(nMatch)) == iCard2 &&
                                    iCard1 >= 49)) { //If the card your not trying to discard is an Ace, then you can discard it.
                                        //Removing for added feature. SetLocalInt(OBJECT_SELF, "PLAYER_CARD_" + IntToString(nMatch), Deal()); //Deal a new card in that slot.
                                        SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(nMatch), 1); //Set as discarded
                                        SendMessageToPC(oPC, ShowHandAndScores("PLAYER")); //Output hand to player.
                                }
                                else { //Else, you can't discard a fourth card unless your remaining card is an Ace.
                                    SendMessageToPC(oPC, "You can't discard a fourth card unless your last card is an Ace.");
                                }
                            }
                            else { //Else that card has been discarded already.
                                SendMessageToPC(oPC, "You've already discarded that card!");
                            }
                }
                else { //Else player has discarded the max amount of cards.
                    SendMessageToPC(oPC,"You've discarded the max amount of cards possible.");
                }
            }
            else if(nMatch > 5) {
                nMatch -= 5;
                if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(nMatch)) == 1) {
                    SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(nMatch), 0);
                    SendMessageToPC(oPC, ShowHandAndScores("PLAYER")); //Output hand to player.
                }
                else {
                    SpeakString("You can only undiscard cards you've perviously marked for discard!");
                }
            }
        }
    }
}
