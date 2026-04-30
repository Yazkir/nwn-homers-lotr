 //::///////////////////////////////////////////////
//:: Custom User Defined Event
//:: wt_user_wander
//::
//:://////////////////////////////////////////////
/*   version 1.5  improved turning and faster
                  travel.
*/

//:://////////////////////////////////////////////
//:: Created By: John Nichols  (masterthief)
//:: Created: 08/10/2002
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"

int WANDER_INIT        = 0;
int WANDER_MOVING      = 1;
int WANDER_TEST_MOVE   = 2;
int WANDER_SEARCHING   = 3;
int WANDER_REST        = 4;

int WANDER_DISABLED    = 255;

object oMaster;

int iTravel            = 10;    //Distance to travel each move
int iTraveled;                  //Distance traveled in WANDER mode
int iMaxDistance       = 100;   //Max distance before rest

int nRand;
int nRand2;

vector vVectorb;
vector vVector;
object oArea;
float fY2;
float fZ2;
float fX;
float fD;
float fZ;
float fY;

location lSelf;
object   oSelf;
location lStartLoc;
location lEndLoc;
int      iDistStrt;
string   sDistStrt;

int      iDistMov;
string   sDistMov;
location lNewLoc;


void WCSetState(int iState)
{
  SetLocalInt(OBJECT_SELF,"WT_NPC_STATE",iState);
}
void WTWANDER_INIT()     //Set to ranged attack if not set
{
    object oMaster;
    oMaster = GetMaster(OBJECT_SELF);
    if(!(GetAssociateState(NW_ASC_USE_RANGED_WEAPON)))
    {
     SetAssociateState(NW_ASC_USE_RANGED_WEAPON);
     DelayCommand(0.2,ActionEquipMostDamagingRanged());
     oMaster = GetMaster(OBJECT_SELF);
    }
    SetLocalInt(OBJECT_SELF,"WT_RIGHTTURN",0);
    SetLocalInt(OBJECT_SELF,"WT_LEFTTURN",0);
    SetLocalInt(OBJECT_SELF,"WT_MAXTRAVEL",iMaxDistance);
    SetLocalInt(OBJECT_SELF,"WT_TRAVELED",0);

    WCSetState(WANDER_MOVING);
}

void WTWANDER_MOVING(int iTraveled, int iMaxDistance)
{
    //ActionSpeakString ("I'm in move script");

    fD = IntToFloat(iTravel);           //Distance to travel

    vVector = GetPosition(OBJECT_SELF); //Get current vector.
    fZ = GetFacing(OBJECT_SELF);        //Get direction facing
    oArea = GetArea(OBJECT_SELF);       //Get area

    //Set current location
    SetLocalLocation(OBJECT_SELF,"WT_NPC_STARTLOC",GetLocation(OBJECT_SELF));
    lStartLoc = GetLocalLocation(OBJECT_SELF,"WT_NPC_STARTLOC");

    // Calculate new positon based on distance and direction facing
    fX = fD * cos(fZ);
    fY = fD * sin(fZ);

    // Fix problems if facing south
    if (fZ > 180.0)
     {
      fY2 = 0.0 - fY;
      fZ2 = (180.0 - (fZ -180.0));
     }
    else
     {
      fY2 = fY;
      fZ2 = fZ;
     }

    // Define location to walk to
    vector vNewVector = Vector(fX, fY2, 0.0);
    vVectorb = vVector + vNewVector;
    lNewLoc = Location(oArea, vVectorb, fZ2);

    //Get walking distance

    float fDistStrt = GetDistanceBetweenLocations(lStartLoc,lNewLoc);
    iDistStrt = FloatToInt(fDistStrt);
    sDistStrt = IntToString(iDistStrt);
    ActionSpeakString ("I am moving to new location " + sDistStrt + " away");
    SetLocalFloat(OBJECT_SELF,"WT_NPC_WALKDIST",fDistStrt);

    //Move to new location
    ActionMoveToLocation(lNewLoc);

    WCSetState(WANDER_TEST_MOVE);

    iTraveled = GetLocalInt(OBJECT_SELF,"WT_TRAVELED");
    int iMax = GetLocalInt(OBJECT_SELF,"WT_MAXTRAVEL");
    if(iTraveled >= iMax)
     {
      WCSetState(WANDER_REST);
     }
}

void WTWANDER_TEST_MOVE()
{
/*
  After the move procedure get the ending
  information for the distance, from start to end
  to see if I really moved or if I hit a wall.
*/

   //Get start location, and distance you wanted to walk
   lStartLoc = GetLocalLocation(OBJECT_SELF,"WT_NPC_STARTLOC");
   float fDistAsk = GetLocalFloat(OBJECT_SELF,"WT_NPC_WALKDIST");

   //Set current location
   SetLocalLocation(OBJECT_SELF,"WT_NPC_ENDLOC",GetLocation(OBJECT_SELF));
   lEndLoc = GetLocalLocation(OBJECT_SELF,"WT_NPC_ENDLOC");

   //Get distance you actually walked (check for walls)
   //Add a 0.5 fudge factor for going around some items in the floor
   float fDistMov = GetDistanceBetweenLocations(lStartLoc,lEndLoc);

   if ((fDistMov + 0.5f) < fDistAsk)
    {
     fZ = GetFacing(OBJECT_SELF);          //Get current direction facing
     string sDistMov = FloatToString(fDistMov);
     ActionSpeakString ("Blocked at " + sDistMov + " facing " + FloatToString(fZ));

     //Control the search pattern can get very fancy if you want to tweek
     //Right now uses random turns of left and right
     //Note if turns right the first time will continue to turn right

     // Pick a new direction to turn
     nRand2 = Random(100);

     int iCountRight = GetLocalInt(OBJECT_SELF,"WT_RIGHTTURN");
     int iCountLeft = GetLocalInt(OBJECT_SELF,"WT_LEFTTURN");

     float fT = 45.0f;
     if(iCountRight > 3 | iCountLeft > 3)
      {
       fZ = fZ - 180.0f;
       iCountRight = iCountRight +1;
       ActionSpeakString ("Turn around " + " facing " + FloatToString(fZ));
       if(iCountRight > 3)
        {
         SetLocalInt(OBJECT_SELF,"WT_RIGHTTURN",1);
        }
       else
       {
        SetLocalInt(OBJECT_SELF,"WT_LEFTTURN",1);
       }
      }
     else
      {
       if((nRand2 > 51 | iCountRight > 0) &&
         (iCountLeft < 1))
         {
          fZ = fZ - fT;
          fT = fT + 5.0f;
          iCountRight = iCountRight +1;
          SetLocalInt(OBJECT_SELF,"WT_RIGHTTURN",iCountRight);
          ActionSpeakString ("Turn to right" + " facing " + FloatToString(fZ));
         }
       else
         {
          fZ = fZ + fT;
          fT = fT + 5.0f;
          iCountLeft = iCountLeft +1;
          SetLocalInt(OBJECT_SELF,"WT_LEFTTURN",iCountLeft);
          ActionSpeakString ("Turn to left" + " facing " + FloatToString(fZ));
         }
      }
      SetFacing(fZ);
      WCSetState(WANDER_TEST_MOVE);
    }
   else
    {
     ActionSpeakString ("I moved it");
     SetLocalInt(OBJECT_SELF,"WT_RIGHTTURN",0);
     SetLocalInt(OBJECT_SELF,"WT_LEFTTURN",0);
     iTraveled = GetLocalInt(OBJECT_SELF,"WT_TRAVELED");
     iTraveled = iTraveled + FloatToInt(fDistMov);  //Add the traveled distance
     SetLocalInt(OBJECT_SELF,"WT_TRAVELED",iTraveled);
     string sTraveled = IntToString(iTraveled);
     int iMax = GetLocalInt(OBJECT_SELF,"WT_MAXTRAVEL");
     string sMax = IntToString(iMax);
     ActionSpeakString ("I have traveled " + sTraveled + " of " + sMax);
     WCSetState(WANDER_SEARCHING);
   }
}

void WTWANDER_SEARCHING()
{
  //ActionSpeakString ("I got to the search test");

  object oMaster = GetMaster();
  //Seek out and move away from traps
  object oTrap = GetNearestTrapToObject();
  if(GetIsObjectValid(oTrap) && GetDistanceToObject(oTrap) < 15.0 && GetDistanceToObject(oTrap) > 0.0)
   {
   ActionMoveAwayFromObject(oTrap, FALSE,40.0f);
   }
}

void WTWANDER_REST()
{
  int iRoll = d20();
  if (iRoll<10)
    if (iRoll == 1 || iRoll == 2)
      {
       ActionSpeakString("*sigh*, I'm tired of walking.");
       ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED);
      }
    else if (iRoll == 3 || iRoll == 4)
     {
      ActionSpeakString("No chair, no bed, This aint good.");
      ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
     }
    else if (iRoll == 5 || iRoll == 6)
     {
      ActionSpeakString("I wonder what trouble i can get into now.");
      ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
     }
    else if (iRoll > 7 || iRoll <10)
     {
      WCSetState(WANDER_INIT);
     }
}

void WTWANDER_DISABLED()
{
}

void main()
{
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1001) //HEARTBEAT
    {
        //ActionSpeakString ("I saw case 1001");
        int iState = GetLocalInt(OBJECT_SELF,"WT_NPC_STATE");
        string sState = IntToString(iState);
        ActionSpeakString ("I'm doing function " + sState);
        if (iState != WANDER_DISABLED)
            switch (iState)
            {
                case 0 : WTWANDER_INIT();break;      //first heartbeat

                case 1 : WTWANDER_MOVING(iTraveled,iMaxDistance);break;

                case 2 : WTWANDER_TEST_MOVE();
                         WTWANDER_MOVING(iTraveled,iMaxDistance);break;

                case 3 : WTWANDER_SEARCHING();break;
                case 4 : WTWANDER_REST();break;
            }
    iState = GetLocalInt(OBJECT_SELF,"WT_NPC_STATE");
    sState = IntToString(iState);
    //ActionSpeakString ("Next heartbeat function " + sState);
    }
    else if(nUser == 1002) // PERCEIVE
    {

    }
    else if(nUser == 1003) // END OF COMBAT
    {

    }
    else if(nUser == 1004) // ON DIALOGUE
    {

    }
    else if(nUser == 1005) // ATTACKED
    {

    }
    else if(nUser == 1006) // DAMAGED
    {

    }
    else if(nUser == 1007) // DEATH
    {

    }
    else if(nUser == 1008) // DISTURBED
    {

    }

}
