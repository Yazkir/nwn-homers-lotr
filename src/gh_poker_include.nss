/*
    Simple Poker game. 5 card draw.
    By: Joe Leonard
    Email: aiden_00@yahoo.com
    Created: 10-10-02

    Hands:
    1. Royal Flush: A, K, Q, J, 10 all of the same suit.
    2. Straight Flush: Any five card sequence in the same suit. (Ex: 7, 8, 9, 10, J and 2, 3, 4, 5, 6 of same suit).
    3. Four of a Kind: All four cards of the same index (Ex: J, J, J, J).
    4. Full House: Three of a kind combined with a pair (Ex: K, K, K, 10, 10).
    5. Flush: Any five cards of the same suit, but not in sequence.
    6. Straight: Five cards in sequence, but not in the same suit.
    7. Three of a Kind: Three cards of the same index. (Ex: 11, 11, 11).
    8. Two Pair: Two separate pairs (Ex: A, A, 8, 8).
    9. Pair: Two cards of the same index. (Ex: 4, 4).
    10. High Card

    Sequence:
    1. Place ante into pot. (Takes MINIMUM bet from PC)
    2. Deal 5 cards.
    3. Betting occurs. Raise / Call / Fold (Raising takes MINIMUM bet from PC)
    4. Discard cards. 3 max, 4 if Ace is held. (PC discards by saying 'discard card #' to the NPC)
    5. Betting occurs. Raise / Call / Fold (Raising takes MINIMUM bet from PC)
    6. Hands revealed, highest hand wins the pot. Start new game. (Pot is awarded to winner)

    Misc:
    Cards are valued as such: A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, 2.
*/

//Initialize functions declarations.
void InitializeDeck();
int Deal();
string CardName(int iCard);
int GetCardValue(int iCard);
string GetSuit(int iCard);
void SortHand(string sWho);
string ShowHandAndScores(string sWho);
string GetHandValue(string sWho);

/* INITIALIZE DECK
    Resets deck so all cards are 'undrawn'.
    The 'Y' and 'N' at the end of the value indicates whether its been drawn or
    not. 'N' = drawn, 'Y' = undrawn or available to be drawn :)
    Also resets the players and dealers hands so they have no cards.
    Also in the value of the cards, I included the suit. H, D, C, S
    Heart, Diamond, Club, Spade.*/
    void InitializeDeck() { //Resets deck and hands so none are 'drawn'.
        SetLocalString(OBJECT_SELF, "1", "02HY"); //TWOS
        SetLocalString(OBJECT_SELF, "2", "02DY");
        SetLocalString(OBJECT_SELF, "3", "02CY");
        SetLocalString(OBJECT_SELF, "4", "02SY");
        SetLocalString(OBJECT_SELF, "5", "03HY"); //THREES
        SetLocalString(OBJECT_SELF, "6", "03DY");
        SetLocalString(OBJECT_SELF, "7", "03CY");
        SetLocalString(OBJECT_SELF, "8", "03SY");
        SetLocalString(OBJECT_SELF, "9", "04HY"); //FOURS
        SetLocalString(OBJECT_SELF, "10", "04DY");
        SetLocalString(OBJECT_SELF, "11", "04CY");
        SetLocalString(OBJECT_SELF, "12", "04SY");
        SetLocalString(OBJECT_SELF, "13", "05HY"); //FIVES
        SetLocalString(OBJECT_SELF, "14", "05DY");
        SetLocalString(OBJECT_SELF, "15", "05CY");
        SetLocalString(OBJECT_SELF, "16", "05SY");
        SetLocalString(OBJECT_SELF, "17", "06HY"); //SIXES
        SetLocalString(OBJECT_SELF, "18", "06DY");
        SetLocalString(OBJECT_SELF, "19", "06CY");
        SetLocalString(OBJECT_SELF, "20", "06SY");
        SetLocalString(OBJECT_SELF, "21", "07HY"); //SEVENS
        SetLocalString(OBJECT_SELF, "22", "07DY");
        SetLocalString(OBJECT_SELF, "23", "07CY");
        SetLocalString(OBJECT_SELF, "24", "07SY");
        SetLocalString(OBJECT_SELF, "25", "08HY"); //EIGHTS
        SetLocalString(OBJECT_SELF, "26", "08DY");
        SetLocalString(OBJECT_SELF, "27", "08CY");
        SetLocalString(OBJECT_SELF, "28", "08SY");
        SetLocalString(OBJECT_SELF, "29", "09HY"); //NINES
        SetLocalString(OBJECT_SELF, "30", "09DY");
        SetLocalString(OBJECT_SELF, "31", "09CY");
        SetLocalString(OBJECT_SELF, "32", "09SY");
        SetLocalString(OBJECT_SELF, "33", "10HY"); //TENS
        SetLocalString(OBJECT_SELF, "34", "10DY");
        SetLocalString(OBJECT_SELF, "35", "10CY");
        SetLocalString(OBJECT_SELF, "36", "10SY");
        SetLocalString(OBJECT_SELF, "37", "11HY"); //JACKS
        SetLocalString(OBJECT_SELF, "38", "11DY");
        SetLocalString(OBJECT_SELF, "39", "11CY");
        SetLocalString(OBJECT_SELF, "40", "11SY");
        SetLocalString(OBJECT_SELF, "41", "12HY"); //QUEENS
        SetLocalString(OBJECT_SELF, "42", "12DY");
        SetLocalString(OBJECT_SELF, "43", "12CY");
        SetLocalString(OBJECT_SELF, "44", "12SY");
        SetLocalString(OBJECT_SELF, "45", "13HY"); //KINGS
        SetLocalString(OBJECT_SELF, "46", "13DY");
        SetLocalString(OBJECT_SELF, "47", "13CY");
        SetLocalString(OBJECT_SELF, "48", "13SY");
        SetLocalString(OBJECT_SELF, "49", "14HY"); //ACES
        SetLocalString(OBJECT_SELF, "50", "14DY");
        SetLocalString(OBJECT_SELF, "51", "14CY");
        SetLocalString(OBJECT_SELF, "52", "14SY");


        //Resetting Dealer and Player hands to 'empty'.
        SetLocalInt(OBJECT_SELF, "PLAYER_CARD_1", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_CARD_2", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_CARD_3", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_CARD_4", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_CARD_5", 0);

        SetLocalInt(OBJECT_SELF, "DEALER_CARD_1", 0);
        SetLocalInt(OBJECT_SELF, "DEALER_CARD_2", 0);
        SetLocalInt(OBJECT_SELF, "DEALER_CARD_3", 0);
        SetLocalInt(OBJECT_SELF, "DEALER_CARD_4", 0);
        SetLocalInt(OBJECT_SELF, "DEALER_CARD_5", 0);

        //Resetting variables used for tracking discarded cards.
        SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_1", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_2", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_3", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_4", 0);
        SetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_5", 0);

    }


/* DEAL ONE CARD!
    Just picks one random card from the deck, if the card is designated with a
    'N' at the end of its value, a different card is picked until one is available.*/
    int Deal() { //Draws random card. Suit and color do not matter in BlackJack.
        int iCard = Random(52) + 1;
        //Iterate through deck till we get a card that is 'available'.
        while(GetStringRight(GetLocalString(OBJECT_SELF, IntToString(iCard)), 1) == "N") {
            iCard = Random(52) + 1;
        }
        //Set that card to NO, so we don't draw it again.
        SetLocalString(OBJECT_SELF, IntToString(iCard), GetStringLeft(GetLocalString(OBJECT_SELF, IntToString(iCard)), 3) + "N");
        return iCard;
    }


/* GET CARD NAME
    Just get the proper name of the card. Jack's, Queen's, King's and Ace's.*/
    string CardName(int iCard) {
        if(iCard >= 1 && iCard <= 36) { //TWOS thru TENS
            return IntToString(StringToInt(GetStringLeft(GetLocalString(OBJECT_SELF, IntToString(iCard)), 2)));
        }
        else if(iCard >= 37 && iCard <= 40) { //JACKS
            return "Jack";
        }
        else if(iCard >= 41 && iCard <= 44) { //QUEENS
            return "Queen";
        }
        else if(iCard >= 45 && iCard <= 48) { //KINGS
            return "King";
        }
        else if(iCard >= 49 && iCard <= 52) { //ACES
            return "Ace";
        }
        else {
            return "Empty";
        }
    }


/* GET CARD VALUE
    10 == 10, King == 13, Ace == 14.*/
    int GetCardValue(int iCard) {
        return StringToInt(GetStringLeft(GetLocalString(OBJECT_SELF, IntToString(iCard)), 2));
    }


/* GET CARD SUIT
    Heart, Spade, Diamond, Club*/
    string GetSuit(int iCard) {
        string sSuit = GetSubString(GetLocalString(OBJECT_SELF, IntToString(iCard)), 2, 1);
        if(sSuit == "H") { //HEARTS
            sSuit = "Heart";
        }
        else if(sSuit == "D") { //DIAMONDS
            sSuit = "Diamond";
        }
        else if(sSuit == "S") { //SPADES
            sSuit = "Spade";
        }
        else if(sSuit == "C") { //CLUBS
            sSuit = "Club";
        }
        return sSuit;
    }


/* SORT CARDS, HIGHEST TO LOWEST
    Sort the cards according to value, A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, 2
    Since cards are already in order in the deck, we need only use the card number
    value from 1 to 52 to determine value. So its Heart Diamond Club Spade in
    order of value according to the deck, although the suits are irrelivent in
    this case, they will be sorted that way.*/
    void SortHand(string sWho) {
        int iCard1 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_1");
        int iCard2 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_2");
        int iCard3 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_3");
        int iCard4 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_4");
        int iCard5 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_5");
        int iCardTemp = 0;
        int HandSorted = FALSE;

        while(HandSorted == FALSE) {
            if(iCard1 > iCard2) { //If larger, continue to next card.
                if(iCard2 > iCard3) { //If larger, continue to next card.
                    if(iCard3 > iCard4) { //If larger, continue to next card.
                        if(iCard4 > iCard5) { //If larger, continue to next card.
                            HandSorted = TRUE; //Cards sorted, looping will stop.
                        }
                        else { //If not larger, swap values.
                            iCardTemp = iCard4;
                            iCard4 = iCard5;
                            iCard5 = iCardTemp;
                        }
                    }
                    else { //If not larger, swap values.
                        iCardTemp = iCard3;
                        iCard3 = iCard4;
                        iCard4 = iCardTemp;
                    }
                }
                else { //If not larger, swap values.
                    iCardTemp = iCard2;
                    iCard2 = iCard3;
                    iCard3 = iCardTemp;
                }
            }
            else { //If not larger, swap values.
                iCardTemp = iCard1;
                iCard1 = iCard2;
                iCard2 = iCardTemp;
            }
        }
        //Cards have been sorted, put them back in the hand.
        SetLocalInt(OBJECT_SELF, sWho + "_CARD_1", iCard1);
        SetLocalInt(OBJECT_SELF, sWho + "_CARD_2", iCard2);
        SetLocalInt(OBJECT_SELF, sWho + "_CARD_3", iCard3);
        SetLocalInt(OBJECT_SELF, sWho + "_CARD_4", iCard4);
        SetLocalInt(OBJECT_SELF, sWho + "_CARD_5", iCard5);
    }


/* SHOW PLAYER OR DEALER HANDS AND SCORES
    Shows the cards and score of the hand */
    string ShowHandAndScores(string sWho) {
        string sHand = GetStringLeft(sWho, 1) + GetStringLowerCase(GetStringRight(sWho, 5)) + ": ";
        if(GetLocalInt(OBJECT_SELF, "DISCARD_TIME") == TRUE) { //If discard time, hide cards.
            int iCount = 0;
            for(iCount = 1; iCount <= 5; iCount++) { //Check each card, if discarded, show as HIDDEN for now.
                if(GetLocalInt(OBJECT_SELF, "PLAYER_DISCARD_" + IntToString(iCount)) == 0) {
                    sHand = sHand + CardName(GetLocalInt(OBJECT_SELF, sWho + "_CARD_" + IntToString(iCount))) + " of " + GetSuit(GetLocalInt(OBJECT_SELF, sWho + "_CARD_" + IntToString(iCount))) + "s, ";
                }
                else {
                    sHand = sHand + "[" + CardName(GetLocalInt(OBJECT_SELF, sWho + "_CARD_" + IntToString(iCount))) + " of " + GetSuit(GetLocalInt(OBJECT_SELF, sWho + "_CARD_" + IntToString(iCount))) + "s], ";
                }
            }
            sHand = GetStringLeft(sHand, GetStringLength(sHand) - 2) + ".";
        }
        else { //Else its not discard time, so dont hide. And also show the hand value.
            SortHand(sWho); //Sort the cards when showing them all.
            sHand = sHand + CardName(GetLocalInt(OBJECT_SELF, sWho + "_CARD_1")) + " of " + GetSuit(GetLocalInt(OBJECT_SELF, sWho + "_CARD_1")) + "s";
            sHand = sHand + ", " + CardName(GetLocalInt(OBJECT_SELF, sWho + "_CARD_2")) + " of " + GetSuit(GetLocalInt(OBJECT_SELF, sWho + "_CARD_2")) + "s";
            sHand = sHand + ", " + CardName(GetLocalInt(OBJECT_SELF, sWho + "_CARD_3")) + " of " + GetSuit(GetLocalInt(OBJECT_SELF, sWho + "_CARD_3")) + "s";
            sHand = sHand + ", " + CardName(GetLocalInt(OBJECT_SELF, sWho + "_CARD_4")) + " of " + GetSuit(GetLocalInt(OBJECT_SELF, sWho + "_CARD_4")) + "s";
            sHand = sHand + ", " + CardName(GetLocalInt(OBJECT_SELF, sWho + "_CARD_5")) + " of " + GetSuit(GetLocalInt(OBJECT_SELF, sWho + "_CARD_5")) + "s";
            sHand = sHand + ".\n" + GetHandValue(sWho);
        }
        return sHand;
    }


/* GET HAND VALUE
    This function gets the hand value. It determines whether the person has
    a straight flush or two pair, or whatever. There are 10 possibilities, from
    a royal flush to a single high card. A point system is also used to
    determine what hand wins when there is a tie in the type of hand they got.
    Like if Player 1 got two pair, A,A,K,K,2 and Player 2 got K,K,Q,Q,4. Player
    1 would win this hand, as his two pair are valued more. I'm going to assume
    that a A,A,3,3,2 would lose to a Q,Q,J,J,2, as the total of the two pair
    from the latter hand is more valuable. */
    string GetHandValue(string sWho) {
        int iCard1 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_1");
        int iCard2 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_2");
        int iCard3 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_3");
        int iCard4 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_4");
        int iCard5 = GetLocalInt(OBJECT_SELF, sWho + "_CARD_5");
        if(sWho == "DEALER") {
            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_1", 0);
            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_2", 0);
            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_3", 0);
            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_4", 0);
            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", 0);
        }
        string sHandName = "NONE";
        int iMainPoints = 0;
        int iFirstPoints = 0;
        int iSecondPoints = 0;

        /* ROYAL FLUSH:
            A, K, Q, J, 10 all of the same suit.*/
            if(sHandName == "NONE") {
                if((iCard1 >= 49 && iCard1 <= 52) && //ACE
                    (iCard2 >= 45 && iCard2 <= 48) && //KING
                    (iCard3 >= 41 && iCard3 <= 44) && //QUEEN
                    (iCard4 >= 37 && iCard4 <= 40) && //JACK
                    (iCard5 >= 33 && iCard5 <= 36)) { //TEN
                        if((GetSuit(iCard1) == GetSuit(iCard2)) && //If all the cards are of the same suit.
                            (GetSuit(iCard2) == GetSuit(iCard3)) &&
                            (GetSuit(iCard3) == GetSuit(iCard4)) &&
                            (GetSuit(iCard4) == GetSuit(iCard5))) {
                                sHandName = "Royal Flush"; //Hand name is found.
                                iMainPoints = 10;
                        }
                }
            }

        /* STRAIGHT FLUSH:
            Any five card sequence in the same suit. (Ex: 7, 8, 9, 10, J and
            2, 3, 4, 5, 6 of same suit).*/
            if(sHandName == "NONE") {
                if((GetSuit(iCard1) == GetSuit(iCard2)) && //If all the cards are of the same suit.
                    (GetSuit(iCard2) == GetSuit(iCard3)) &&
                    (GetSuit(iCard3) == GetSuit(iCard4)) &&
                    (GetSuit(iCard4) == GetSuit(iCard5))) {
                        if(((GetCardValue(iCard1) > GetCardValue(iCard2)) &&
                            (GetCardValue(iCard2) > GetCardValue(iCard3)) &&
                            (GetCardValue(iCard3) > GetCardValue(iCard4)) &&
                            (GetCardValue(iCard4) > GetCardValue(iCard5))) &&
                            (GetCardValue(iCard1) - GetCardValue(iCard5) == 4)) {
                                sHandName = "Straight Flush"; //Hand name is found.
                                iMainPoints = 9;
                                iFirstPoints = GetCardValue(iCard1);
                        }
                }
            }

        /*FOUR OF A KIND:
            All four cards of the same index (Ex: J, J, J, J).*/
            if(sHandName == "NONE") {
                if((CardName(iCard1) == CardName(iCard2)) && //If the first four cards are the same type.
                    (CardName(iCard2) == CardName(iCard3)) &&
                    (CardName(iCard3) == CardName(iCard4))) {
                        sHandName = "Four of a Kind"; //Hand name is found.
                        iMainPoints = 8;
                        iFirstPoints = GetCardValue(iCard1);
                        iSecondPoints = GetCardValue(iCard5);
                        if(iCard5 <= 24) {
                            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5); //Cards dealer is to discard.
                        }
                }
                else if((CardName(iCard2) == CardName(iCard3)) && //If the last four cards are the same type.
                    (CardName(iCard3) == CardName(iCard4)) &&
                    (CardName(iCard4) == CardName(iCard5))) {
                        sHandName = "Four of a Kind"; //Hand name is found.
                        iMainPoints = 8;
                        iFirstPoints = GetCardValue(iCard2);
                        iSecondPoints = GetCardValue(iCard1);
                        if(iCard1 <= 24) {
                            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_1", iCard1); //Cards dealer is to discard.
                        }
                }
            }

        /*FULL HOUSE:
            Three of a kind combined with a pair (Ex: K, K, K, 10, 10).*/
            if(sHandName == "NONE") {
                if((CardName(iCard1) == CardName(iCard2) && //If the first three cards are the same, and the last two.
                    CardName(iCard2) == CardName(iCard3)) &&
                    CardName(iCard4) == CardName(iCard5)) {
                        sHandName = "Full House"; //Hand name is found.
                        iMainPoints = 7;
                        iFirstPoints = GetCardValue(iCard1);
                        iSecondPoints = GetCardValue(iCard4);
                }
                else if(CardName(iCard1) == CardName(iCard2) && //If the first two cards are the same, and the last three.
                    (CardName(iCard3) == CardName(iCard4) &&
                    CardName(iCard4) == CardName(iCard5))) {
                        sHandName = "Full House"; //Hand name is found.
                        iMainPoints = 7;
                        iFirstPoints = GetCardValue(iCard1);
                        iSecondPoints = GetCardValue(iCard3);
                }
            }

        /*FLUSH:
            Any five cards of the same suit, but not in sequence.*/
            if(sHandName == "NONE") {
                if(GetSuit(iCard1) == GetSuit(iCard2) && //If all the cards are of the same suit.
                    GetSuit(iCard2) == GetSuit(iCard3) &&
                    GetSuit(iCard3) == GetSuit(iCard4) &&
                    GetSuit(iCard4) == GetSuit(iCard5)) {
                        sHandName = "Flush"; //Hand name is found.
                        iMainPoints = 6;
                        iFirstPoints = GetCardValue(iCard1) + GetCardValue(iCard2) + GetCardValue(iCard3) + GetCardValue(iCard4) + GetCardValue(iCard5);
                }
            }

        /*STRAIGHT:
            Five cards in sequence, but not in the same suit.*/
            if(sHandName == "NONE") {
                if(((GetCardValue(iCard1) > GetCardValue(iCard2)) &&
                        (GetCardValue(iCard2) > GetCardValue(iCard3)) &&
                        (GetCardValue(iCard3) > GetCardValue(iCard4)) &&
                        (GetCardValue(iCard4) > GetCardValue(iCard5))) &&
                        (GetCardValue(iCard1) - GetCardValue(iCard5) == 4)) {
                            sHandName = "Straight"; //Hand name is found.
                            iMainPoints = 5;
                            iFirstPoints = GetCardValue(iCard1);
                }
            }

        /*THREE OF A KIND:
            Three cards of the same index.*/
            if(sHandName == "NONE") {
                if(CardName(iCard1) == CardName(iCard2) && //First three cards
                    CardName(iCard2) == CardName(iCard3)) {
                        sHandName = "Three of a Kind"; //Hand name is found.
                        iMainPoints = 4;
                        iFirstPoints = GetCardValue(iCard1);
                        iSecondPoints = GetCardValue(iCard4);
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_4", iCard4); //Cards dealer is to discard.
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5);
                }
                else if(CardName(iCard2) == CardName(iCard3) && //Middle three cards
                    CardName(iCard3) == CardName(iCard4)) {
                        sHandName = "Three of a Kind"; //Hand name is found.
                        iMainPoints = 4;
                        iFirstPoints = GetCardValue(iCard2);
                        iSecondPoints = GetCardValue(iCard1);
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_1", iCard1); //Cards dealer is to discard.
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5);
                }
                else if(CardName(iCard3) == CardName(iCard4) && //Last three cards
                    CardName(iCard4) == CardName(iCard5)) {
                        sHandName = "Three of a Kind"; //Hand name is found.
                        iMainPoints = 4;
                        iFirstPoints = GetCardValue(iCard3);
                        iSecondPoints = GetCardValue(iCard1);
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_1", iCard1); //Cards dealer is to discard.
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_2", iCard2);
                }
            }

        /*TWO PAIR:
            Two separate pairs (Ex: A, A, 8, 8).*/
            if(sHandName == "NONE") {
                if((CardName(iCard1) == CardName(iCard2) && //First four are two pair.
                    CardName(iCard3) == CardName(iCard4))) {
                        sHandName = "Two Pair"; //Hand name is found.
                        iMainPoints = 3;
                        iFirstPoints = GetCardValue(iCard1) + GetCardValue(iCard3);
                        iSecondPoints = GetCardValue(iCard5);
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5); //Cards dealer is to discard.
                }
                else if((CardName(iCard2) == CardName(iCard3) && //Last four are two pair.
                    CardName(iCard4) == CardName(iCard5))) {
                        sHandName = "Two Pair"; //Hand name is found.
                        iMainPoints = 3;
                        iFirstPoints = GetCardValue(iCard2) + GetCardValue(iCard4);
                        iSecondPoints = GetCardValue(iCard1);
                        if(iCard1 <= 24) { //If dealer has 8 or greater, don't discard.
                            SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_1", iCard1); //Cards dealer is to discard.
                        }
                }
                else if((CardName(iCard1) == CardName(iCard2) && //First two and last two make two pair.
                    CardName(iCard4) == CardName(iCard5))) {
                        sHandName = "Two Pair"; //Hand name is found.
                        iMainPoints = 3;
                        iFirstPoints = GetCardValue(iCard1) + GetCardValue(iCard4);
                        iSecondPoints = GetCardValue(iCard3);
                        SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_3", iCard3); //Cards dealer is to discard.
                }
            }

        /*PAIR:
            Two cards of the same index.*/
            if(sHandName == "NONE") {
                if(CardName(iCard1) == CardName(iCard2)) { //Cards 1 and 2.
                    sHandName = "One Pair"; //Hand name is found.
                    iMainPoints = 2;
                    iFirstPoints = GetCardValue(iCard1);
                    iSecondPoints = GetCardValue(iCard3);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_3", iCard3); //Cards dealer is to discard.
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_4", iCard4);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5);
                }
                else if(CardName(iCard2) == CardName(iCard3)) { //Cards 2 and 3.
                    sHandName = "One Pair"; //Hand name is found.
                    iMainPoints = 2;
                    iFirstPoints = GetCardValue(iCard2);
                    iSecondPoints = GetCardValue(iCard1);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_4", iCard4); //Cards dealer is to discard.
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5);
                }
                else if(CardName(iCard3) == CardName(iCard4)) { //Cards 3 and 4.
                    sHandName = "One Pair"; //Hand name is found.
                    iMainPoints = 2;
                    iFirstPoints = GetCardValue(iCard3);
                    iSecondPoints = GetCardValue(iCard1);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_2", iCard2); //Cards dealer is to discard.
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5);
                }
                else if(CardName(iCard4) == CardName(iCard5)) { //Cards 4 and 5.
                    sHandName = "One Pair"; //Hand name is found.
                    iMainPoints = 2;
                    iFirstPoints = GetCardValue(iCard4);
                    iSecondPoints = GetCardValue(iCard1);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_2", iCard2); //Cards dealer is to discard.
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_3", iCard3);
                }
            }

        /*HIGH CARD*/
            if(sHandName == "NONE") {
                sHandName = "High card: " + CardName(iCard1);
                iMainPoints = 1;
                iFirstPoints = GetCardValue(iCard1);
                if(iCard1 >= 49) { //If card 1 is an Ace, then discard four cards.
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_2", iCard2); //Cards dealer is to discard.
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_3", iCard3);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_4", iCard4);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5);
                }
                else{
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_3", iCard3); //Cards dealer is to discard.
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_4", iCard4);
                    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", iCard5);
                }
            }

        SetLocalInt(OBJECT_SELF, sWho + "_SCORE_MAIN", iMainPoints);
        SetLocalInt(OBJECT_SELF, sWho + "_SCORE_FIRST", iFirstPoints);
        SetLocalInt(OBJECT_SELF, sWho + "_SCORE_SECOND", iSecondPoints);
        return sHandName;
    }


