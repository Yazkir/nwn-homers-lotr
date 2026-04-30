/*
    Simple Poker game. 5 card draw.
    By: Joe Leonard
    Email: aiden_00@yahoo.com
    Created: 10-10-02

    If the player called in the first round. Do not increase the pot
    and continue on to the 'discard' round.
*/
void main()
{
    //Turn on the discard round.
    SetLocalInt(OBJECT_SELF, "DISCARD_TIME", TRUE);
}
