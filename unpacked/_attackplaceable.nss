//Made by Jehke (Second script I've ever done!111)
void main()
{
object oAttacker = GetLastAttacker();
effect eDeath = EffectPetrify();

ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDeath,oAttacker,10.0f);
ActionSpeakString("Don't attack placeables.");
}

