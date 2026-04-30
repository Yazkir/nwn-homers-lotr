//Function to randomly assign an order and price
void DrinkOrder()
{
    string sOrder;
    string sAmount;

    int oOrder = d4();

    switch(oOrder)
 {

    case 1:
        sOrder = "Gimme a Fire Breath please.";
        sAmount = "That'll be 8 gold.";
        break;
    case 2:
        sOrder = "I'll have an ale please.";
        sAmount = "That'll be 2 gold.";
        break;
    case 3:
        sOrder = "Some wine please.";
        sAmount ="That'll be 4 gold.";
        break;
    case 4:
        sOrder = "How 'bout some spirits please.";
        sAmount = "That'll be 7 gold.";
        break;
  }
    SetLocalString(OBJECT_SELF, "CW_ORDER", sOrder);
    SetLocalString(OBJECT_SELF, "CW_AMOUNT", sAmount);
}


void main()
{

// Variable and Object Initialization
int randpatron = d10();
object oPatron = GetObjectByTag("cw_patron", randpatron);
object oBartender = GetObjectByTag("Delia");
object oBar = GetWaypointByTag("cw_bar");

//Get random drink order and price.
DrinkOrder();

//Move to Patron, talk, and do action
ActionMoveToObject(oPatron, FALSE, 2.0);
ActionSpeakString("Hey there, What can I get ya?");
ActionWait(2.5);

//Move to Bar, give order
ActionMoveToObject(oBar, FALSE, 1.0);
ActionSpeakString(GetLocalString(OBJECT_SELF, "CW_ORDER"));
ActionWait(7.5);

//Move back to Patron, get money
ActionMoveToObject(oPatron, FALSE, 2.0);
ActionSpeakString("Here's your drink");
ActionSpeakString(GetLocalString(OBJECT_SELF, "CW_AMOUNT"));
ActionWait(2.0);
ActionSpeakString("Thanks!!");
ActionWait(1.5);

}


