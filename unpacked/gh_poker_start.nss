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

This initial code starts the game of poker, including initializes the deck,
clearing the player and dealer hands of cards, resetting the pot, and
clearing the scores. It sets the PCSpeaker as "PLAYING".
*/

#include "gh_poker_include"

void main()
{
    //Get the PC object.
    object oPC = GetPCSpeaker();

    //Pot of money and bets.
    SetLocalInt(OBJECT_SELF, "MONEY_POT", 0);
    SetLocalInt(OBJECT_SELF, "MINIMUM_BET", 500);

    //Set player as "PLAYING"
    SetLocalInt(oPC, "IS_PLAYING_POKER", TRUE);

    //Increase pot to starting ante. Player bet + Dealer bet.
    TakeGoldFromCreature(GetLocalInt(OBJECT_SELF, "MINIMUM_BET"), oPC, FALSE);
    SetLocalInt(OBJECT_SELF, "MONEY_POT", (GetLocalInt(OBJECT_SELF, "MINIMUM_BET") * 2));

    //Initialize deck.
    InitializeDeck();

    //Deal cards to players hands.
    SetLocalInt(OBJECT_SELF, "PLAYER_CARD_1", Deal());
    SetLocalInt(OBJECT_SELF, "DEALER_CARD_1", Deal());
    SetLocalInt(OBJECT_SELF, "PLAYER_CARD_2", Deal());
    SetLocalInt(OBJECT_SELF, "DEALER_CARD_2", Deal());
    SetLocalInt(OBJECT_SELF, "PLAYER_CARD_3", Deal());
    SetLocalInt(OBJECT_SELF, "DEALER_CARD_3", Deal());
    SetLocalInt(OBJECT_SELF, "PLAYER_CARD_4", Deal());
    SetLocalInt(OBJECT_SELF, "DEALER_CARD_4", Deal());
    SetLocalInt(OBJECT_SELF, "PLAYER_CARD_5", Deal());
    SetLocalInt(OBJECT_SELF, "DEALER_CARD_5", Deal());

    //Player and Dealer scores. Used for AI and figuring out a winner.
    SetLocalInt(OBJECT_SELF, "PLAYER_SCORE_MAIN", 0);
    SetLocalInt(OBJECT_SELF, "PLAYER_SCORE_FIRST", 0);
    SetLocalInt(OBJECT_SELF, "PLAYER_SCORE_SECOND", 0);
    SetLocalInt(OBJECT_SELF, "DEALER_SCORE_MAIN", 0);
    SetLocalInt(OBJECT_SELF, "DEALER_SCORE_FIRST", 0);
    SetLocalInt(OBJECT_SELF, "DEALER_SCORE_SECOND", 0);

    //Dealer discard cards.
    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_1", 0);
    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_2", 0);
    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_3", 0);
    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_4", 0);
    SetLocalInt(OBJECT_SELF, "DEALER_DISCARD_5", 0);

    //Show hands.
    SendMessageToPC(oPC, "The pot is: " + IntToString(GetLocalInt(OBJECT_SELF, "MONEY_POT")));
    SendMessageToPC(oPC, ShowHandAndScores("PLAYER"));
}
