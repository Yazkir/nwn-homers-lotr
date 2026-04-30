  //Custom OnDeath script to replace encounter
//triggers and CPU hogging on heartbeat events


#include "NW_I0_GENERIC"

void main()
{

    //This stuff comes from the default onDeath script
    //from Bioware.

    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);

    object oKiller = GetLastKiller();
    // Is this object a PC?

    // Increment the killer var
    int iKilled = GetLocalInt (oKiller,"iKilled");
    ++iKilled;
    SetLocalInt(oKiller,"iKilled",iKilled);
       // Dem Sprecher EP geben
    //GiveXPToCreature(GetLastAttacker(), 1000);

    // Dem Sprecher die Gegenstände geben
    //CreateItemOnObject("reward", GetLastAttacker(), 1);

    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);

    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
     {
     SignalEvent(OBJECT_SELF, EventUserDefined(1007));
     }



   //Here you can call functions or place code to
   //Give the PC experience and treasure. This
   //tests to make sure the player didn't kill
   //another player.  If the player didn't then
   //call functions to reward the player

   if( !GetIsPC( OBJECT_SELF ) )
      {
      //Call fucntions to reward the player
      }

    //Create a copy of the creature that died
    //and put it in the Area Encounter Limbo
    //Assign a delayed command to portal back
    //to the location where it died.

    //I've put this LOOPS varible in here to make
    //sure this code is only fired once.  I'm
    //not sure why, but without this, sometimes
    //when a creature is killed this script will
    //execute 7 or 8 times.  However, this local
    //varible test seems to fix the problem.

    if(GetLocalInt(OBJECT_SELF, "LOOPS") < 1)
      {

      //This is getting the waypoint object where you
      //want the creatures to wait in limbo at.
      //Here I've given the waypoint tag the value
      //"way_hostile" and put the waypoint in the
      //encounter limbo area.
      object oWayLimbo = GetWaypointByTag("way_hostile");

      //This gets the location of your specified waypoint
      location lWayLimbo = GetLocation(oWayLimbo);

      //This gets the location of where the creature died.
      location lDied = GetLocation(OBJECT_SELF);

      //This is an alternative to respawning the creature
      //where they dropped.  To use this, put a waypoint
      //next to the creature in the map and the creature will
      //spawn there instead of where it fell.  I use this
      //myself and basically I put a waypoint next to each
      //group of encounters I make even if it is for only
      //one encounter.
      //
      //object oWayClose = GetNearestObject(OBJECT_TYPE_WAYPOINT, OBJECT_SELF);
      //location lWayClose = GetLocation(oWayClose);

      //This gets the Blueprint ResRef of the killed creature for
      //use in the CreateObject function
      string sResRef = GetResRef(OBJECT_SELF);

      //Create the copy of the killed creature at the location of the
      //waypoint specified in the encounter limbo area.
      object oCreate = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lWayLimbo, FALSE);

      //Tell the newly created creature to jump back after so many seconds.
      //If using the waypoint idea above instead of where the encounter
      //fell, replace lDied with lWayClose, and make sure to put waypoints
      //near the encounters.  You don't have to give these waypoints any
      //special values.
      AssignCommand(oCreate, DelayCommand(500.0, ActionJumpToLocation(lDied)));

      //Set the local check varible so that this script won't fire this code
      //more than once.  Again, I'm not sure why this happens?
      SetLocalInt(OBJECT_SELF, "LOOPS", 1);
      }

}
