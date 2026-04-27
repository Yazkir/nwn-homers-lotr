// HB for bees, stings closest NPC
#include "nw_i0_plot"


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
    SendMessageToPC(oNearestPC,"The "+sCName+" manage to sneak inside your armor and begin to sting you profusely.");
     // sting dmg
    int iRakeDmg = d100(1)+69;
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(iRakeDmg,DAMAGE_TYPE_PIERCING,DAMAGE_POWER_NORMAL),oNearestPC);
    }
}
