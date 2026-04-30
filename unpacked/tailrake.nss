//grabs the closest NPC and does sum dmg to em, goes on HB
#include "nw_i0_plot"
#include "nw_i0_generic"


float fIncDist = 30.0;

// Find the location of self and nearest PC
location lSelfLoc = GetLocation(OBJECT_SELF);
object oNearestPC = GetNearestPC();
location lNearPC = GetLocation(oNearestPC);
// Find the distance between self and nearest PC
float fPCDistance = GetDistanceBetween(OBJECT_SELF,oNearestPC);

// Begin main code
void main()
{

// Get the Nearest PC
object oNearestPC = GetNearestPC();
// Perform a melee touch attack
int iTA = TouchAttackMelee(oNearestPC,FALSE);
// Get the distance between the creature and the pc
float fDBetween = GetDistanceBetween(OBJECT_SELF,oNearestPC);
// Check if the melee touch attack hit, if the pc is valid, and within 3 meters
if ((iTA > 0) && (oNearestPC != OBJECT_INVALID) && (fDBetween <= 3.0))
    {
    // Get the name of the grappling creature, display a message, grapple, and rake the PC
    string sCName = GetName(OBJECT_SELF);
    // Decrease the PC's movement for 1d4+4 seconds (Grappled)
    int id4 = d4(1)+4;
    float fd4 = IntToFloat(id4);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectMovementSpeedDecrease(99),oNearestPC,fd4);
    AssignCommand(oNearestPC,JumpToObject(OBJECT_SELF));
    PlayAnimation(ANIMATION_FIREFORGET_TAUNT,1.25,2.0);
    SendMessageToPC(oNearestPC,"The "+sCName+" grapples you and rakes you with its claws.");
     // dmg amount
    int iRakeDmg = d100(1)+120;
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(iRakeDmg,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL),oNearestPC);
    }

    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

    // Buff ourselves up right away if we should
    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
    {
        // This will return TRUE if an enemy was within 40.0 m
        // and we buffed ourselves up instantly to respond --
        // simulates a spellcaster with protections enabled
        // already.
        if(TalentAdvancedBuff(40.0))
        {
            // This is a one-shot deal
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);

            // This return means we skip sending the user-defined
            // heartbeat signal in this one case.
            return;
        }
    }


    if(GetHasEffect(EFFECT_TYPE_SLEEP))
    {
        // If we're asleep and this is the result of sleeping
        // at night, apply the floating 'z's visual effect
        // every so often

        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
            if(d10() > 6)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            }
        }
    }

    // If we have the 'constant' waypoints flag set, walk to the next
    // waypoint.
    else if ( GetWalkCondition(NW_WALK_FLAG_CONSTANT) )
    {
        WalkWayPoints();
    }

    // Check to see if we should be playing default animations
    // - make sure we don't have any current targets
    else if ( !GetIsObjectValid(GetAttemptedAttackTarget())
          && !GetIsObjectValid(GetAttemptedSpellTarget())
          // && !GetIsPostOrWalking())
          && !GetIsObjectValid(GetNearestSeenEnemy()))
    {
        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL) || GetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE) ||
            GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE))
        {
            // This handles special attacking/fleeing behavior
            // for omnivores & herbivores.
            DetermineSpecialBehavior();
        }
        else if (!IsInConversation(OBJECT_SELF))
        {
            if (GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS)
                || GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN)
                || GetIsEncounterCreature())
            {
                PlayMobileAmbientAnimations();
            }
            else if (GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS))
            {
                PlayImmobileAmbientAnimations();
            }
        }
    }

    // Send the user-defined event signal if specified
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }



}
